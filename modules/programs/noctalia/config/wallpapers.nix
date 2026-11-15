{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/43-wallpapers.toml".source = (pkgs.formats.toml {}).generate "43-wallpapers.toml" {
      "wallpaper" = {
        "directory" = "/mnt/storage/wallpapers";
        "transition" = [
          "melt"
        ];
        "default" = {
          "path" = "/mnt/storage/wallpapers/wallhaven-m313vk.jpg";
        };
        "last" = {
          "path" = "/mnt/storage/wallpapers/wallhaven-m313vk.jpg";
        };
        "monitors" = {
          "DP-1" = {
            "path" = "/mnt/storage/wallpapers/wallhaven-m313vk.jpg";
          };
          "DP-2" = {
            "path" = "/mnt/storage/wallpapers/wallhaven-m313vk.jpg";
          };
          "WL-1" = {
            "path" = "/mnt/storage/wallpapers/seaside-bus-stop-view.png";
          };
        };
        "favorite" = [
          {
            "custom_palette" = "dark-green";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/wallhaven-lqrwqy.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-mld9jk.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "vibrant";
          }
          {
            "custom_palette" = "sakura-overdrive";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/wallhaven-zypj7v.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/girl_blue_flowers.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "vibrant";
          }
          {
            "custom_palette" = "dark-red";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/zerotwo.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-o5rjq9.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "m3-monochrome";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/foxgirl.png";
            "theme_mode" = "light";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-zp5r8y.png";
            "theme_mode" = "auto";
            "wallpaper_scheme" = "faithful";
          }
          {
            "custom_palette" = "dark-green";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/wallhaven-k8ldjq.jpg";
            "theme_mode" = "dark";
          }
          {
            "builtin_palette" = "Catppuccin";
            "palette_source" = "builtin";
            "path" = "/mnt/storage/wallpapers/wallhaven-1qkz23.png";
            "theme_mode" = "dark";
          }
          {
            "builtin_palette" = "Ayu";
            "palette_source" = "builtin";
            "path" = "/mnt/storage/wallpapers/ayu-dark.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/space.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "muted";
          }
          {
            "builtin_palette" = "Gruvbox";
            "palette_source" = "builtin";
            "path" = "/mnt/storage/wallpapers/gruv-space.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-x8ye3z.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "custom_palette" = "verdant-nocturne";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/catgirl_green.png";
            "theme_mode" = "light";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/seaside-bus-stop-view.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-qrogxr.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/nazuna-nanakusa-yofukashi-no-uta-vampire-girl-anime-girls-hd-wallpaper-b8460de8d0d09cc8506c01be7832243a.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-8gjd9y.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-5gvpg7.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-jedmwq.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/girl_horns.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "community_palette" = "Everforest";
            "palette_source" = "community";
            "path" = "/mnt/storage/wallpapers/everforest/everforest_girl_monster.png";
            "theme_mode" = "dark";
          }
          {
            "custom_palette" = "verdant-nocturne";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/girl_sitting.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/kaltsit-cat.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "faithful";
          }
          {
            "custom_palette" = "verdant-nocturne";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/wallhaven-m313vk.jpg";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-og77m7.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "m3-content";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/girls_sun.png";
            "theme_mode" = "light";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-1pxl59.png";
            "theme_mode" = "light";
            "wallpaper_scheme" = "soft";
          }
          {
            "custom_palette" = "space";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/Cloudy_Quasar_1.png";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/56ccpIX.jpeg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "dysfunctional";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/halloween.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "custom_palette" = "verdant-nocturne";
            "palette_source" = "custom";
            "path" = "/mnt/storage/wallpapers/wallhaven-7pvpwy.png";
            "theme_mode" = "dark";
          }
          {
            "builtin_palette" = "Catppuccin";
            "palette_source" = "builtin";
            "path" = "/mnt/storage/wallpapers/noctalia-wallpaper.png";
            "theme_mode" = "dark";
          }
          {
            "builtin_palette" = "Rosé Pine";
            "palette_source" = "builtin";
            "path" = "/mnt/storage/wallpapers/wallhaven-5yp2j9.jpg";
            "theme_mode" = "dark";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/interlude_109.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "m3-content";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/migu.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "m3-content";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-q661dq.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-21j1vx.png";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
          {
            "palette_source" = "wallpaper";
            "path" = "/mnt/storage/wallpapers/wallhaven-yqwe1d.jpg";
            "theme_mode" = "dark";
            "wallpaper_scheme" = "soft";
          }
        ];
      };
    };
  };
}
