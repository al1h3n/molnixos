"""A shared two-texel image with independent sharp/smooth glTF samplers."""
import json
from pathlib import Path
import struct
import sys
import zlib

out=Path(sys.argv[1])
out.mkdir(exist_ok=True)
def chunk(kind,data):
    return struct.pack('>I',len(data))+kind+data+struct.pack('>I',zlib.crc32(kind+data)&0xffffffff)
png=b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',2,1,8,6,0,0,0))
png+=chunk(b'IDAT',zlib.compress(bytes([0,255,0,0,255,0,0,255,255])))+chunk(b'IEND',b'')
for authored in [False,True]:
    binary=bytearray()
    doc={'asset':{'version':'2.0'},'scene':0,'scenes':[{'nodes':[0]}],
         'nodes':[{'mesh':0}],'meshes':[{'primitives':[]}],'bufferViews':[],
         'accessors':[],'buffers':[{}],'images':[],'textures':[],
         'samplers':[{'magFilter':9728,'minFilter':9986},{'magFilter':9729,'minFilter':9987}],
         'materials':[]}
    def view(data):
        while len(binary)%4: binary.append(0)
        start=len(binary);binary.extend(data)
        doc['bufferViews'].append({'buffer':0,'byteOffset':start,'byteLength':len(data)})
        return len(doc['bufferViews'])-1
    def accessor(values,kind):
        rows=values if isinstance(values[0],tuple) else [(v,) for v in values]
        data=struct.pack('<'+'f'*sum(map(len,rows)),*(v for row in rows for v in row))
        doc['accessors'].append({'bufferView':view(data),'componentType':5126,
            'count':len(rows),'type':kind,'min':[min(r[i]for r in rows)for i in range(len(rows[0]))],
            'max':[max(r[i]for r in rows)for i in range(len(rows[0]))]})
        return len(doc['accessors'])-1
    for i,(left,right) in enumerate([(-1,0),(0,1)]):
        pos=[(left,-1,0),(right,-1,0),(right,1,0),(left,-1,0),(right,1,0),(left,1,0)]
        doc['meshes'][0]['primitives'].append({'attributes':{
            'POSITION':accessor(pos,'VEC3'),'NORMAL':accessor([(0,0,1)]*6,'VEC3'),
            'TEXCOORD_0':accessor([(.5,.5)]*6,'VEC2')},'material':i})
        texture={'source':0}
        if authored: texture['sampler']=i
        doc['textures'].append(texture)
        doc['materials'].append({'pbrMetallicRoughness':{'baseColorTexture':{'index':i},'metallicFactor':0}})
    doc['images']=[{'bufferView':view(png),'mimeType':'image/png'}]
    doc['buffers'][0]['byteLength']=len(binary)
    js=json.dumps(doc).encode();js+=b' '*((-len(js))%4)
    binary+=b'\0'*((-len(binary))%4)
    data=struct.pack('<4sII',b'glTF',2,28+len(js)+len(binary))
    data+=struct.pack('<I4s',len(js),b'JSON')+js+struct.pack('<I4s',len(binary),b'BIN\0')+binary
    (out/('authored.glb' if authored else 'default.glb')).write_bytes(data)
