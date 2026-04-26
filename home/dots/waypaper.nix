{ variables, ... }: {
  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    folder = ${variables.media}/static
             ${variables.media}/video
    post_command = sh ${variables.lshared}/scripts/borderline.sh $wallpaper
    number_of_columns = 5
    swww_transition_type = random
    swww_transition_fps = 144
    mpvpaper_options = -s -o "--gpu-api=vulkan --loop --mute --no-osd-bar --no-input-default-bindings" ALL $video
    stylesheet = ${variables.lshared}/config/waypaperstyle
    fill = stretch
    subfolders = True
    all_subfolders = True
    show_hidden = True
    mpvpaper_sound = False
  '';
}
# CHECK --gpu-api=vulkan