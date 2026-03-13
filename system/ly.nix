{ pkgs, ... }: {
  services.displayManager.ly = {
    enable = true;
    
    settings = {
      # 1. Design
      border_fg = "0x80FFFFFF";
      hide_borders = false;
      
      margin_box_h = 1;
      margin_box_v = 0;
      input_len = 25;
      
      animation = "colormix";
      
      # 1.3.2. DOOM (fire)
      doom_fire_spread = 2;
      doom_top_color = "0x009F2707";
      doom_middle_color = "0x00C78F17";
      doom_bottom_color = "0x00FFFFFF";
      doom_fire_height = 5;
      
      # 1.3.3. Game of life
      gameoflife_entropy_interval = 0;
      gameoflife_fg = "0x0000FF00";
      gameoflife_frame_delay = 1;
      gameoflife_initial_density = "0.4";
      
      # 1.3.4. Color mix
      colormix_col1 = "0x003b3b3b";
      colormix_col2 = "0x00222222";
      colormix_col3 = "0x00808080";
      
      # 2. Password
      asterisk = "0x2022";
      auth_fails = 10;
      clear_password = false;
      
      # 3. Information
      battery_id = "BAT0";
      
      bigclock = "en";
      bigclock_seconds = true;
      clock = "%A, %B %-d";
      
      box_title = "MOLNIX OS";
      hide_version_string = true;
      initial_info_text = "Welcome back!";
      
      # 4. Functionality
      default_input = "password";
      hide_key_hints = true;
      
      # Note: Replaced /usr/bin/ with direct Nix store binary paths!
      brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q -n s 10%-";
      brightness_down_key = "F5";
      brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q -n s +10%";
      brightness_up_key = "F6";
      
      hibernate_key = "F3";
      hibernate_cmd = "systemctl hybrid-sleep";
      sleep_key = "F4";
      sleep_cmd = "systemctl sleep";
      inactivity_cmd = "systemctl sleep";
      inactivity_delay = 120;
    };
  };
}