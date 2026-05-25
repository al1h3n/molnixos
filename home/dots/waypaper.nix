{ variables, ... }: {
  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    folder = ${variables.media}/static
             ${variables.media}/video
    post_command = sh ${variables.lshared}/scripts/molnipaper.sh $wallpaper $video
    number_of_columns = 5
    swww_transition_type = random
    swww_transition_fps = 144
    mpvpaper_options = -s -o "--gpu-api=vulkan --loop --mute --cache=no --demuxer-max-bytes=1000000 --demuxer-max-back-bytes=0" ALL $video
    stylesheet = ${variables.lshared}/config/waypaperstyle
    fill = stretch
    subfolders = True
    all_subfolders = True
    show_hidden = True
    mpvpaper_sound = False
  '';
}
# CHECK --gpu-api=vulkan, if still not working try OpenGL.
# Demuxer: 1MiB to Bytes