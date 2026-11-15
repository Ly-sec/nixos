{
  flake.modules.homeManager."vesktop" = {
    config,
    pkgs,
    ...
  }: {
    home.file.".config/vesktop/themes/system24-noktis.theme.css".text = ''
       /*
      * @name system24 (Dark Red)
      * @description Base16-aligned Oxocarbon Dark TUI-style theme for Discord via Vesktop.
      * @author refact0r (adapted by ChatGPT)
      */

      @import url("https://refact0r.github.io/system24/build/system24.css");

      .containerDefault-3GGEv_ .unread-36eUEm .name-3Uvkvr,
      .containerDefault-3GGEv_ .unread-36eUEm .icon-3AqZ2e {
        color: var(--base06) !important;
      }

      /* Unread channel styling */
      .containerDefault-3GGEv_ .unread-36eUEm {
        background-color: var(--base0E) !important;
        opacity: 0.3;
      }

      .containerDefault-3GGEv_ .unread-36eUEm .name-3Uvkvr {
        color: var(--base05) !important;
        font-weight: 500;
      }

      .containerDefault-3GGEv_ .unread-36eUEm .icon-3AqZ2e {
        color: var(--base05) !important;
      }

      /* Unread mentions styling */
      .containerDefault-3GGEv_ .unread-36eUEm .mentionsBadge-3HnHJv {
        background-color: var(--base0E) !important;
        color: var(--base05) !important;
      }

      /* Force Oxocarbon background everywhere */
      .theme-dark,
      .theme-light,
      :root {
        --background-primary: #161616 !important;
        --background-secondary: #161616 !important;
        --background-secondary-alt: #161616 !important;
        --background-tertiary: #161616 !important;
        --background-mobile-primary: #161616 !important;
        --background-mobile-secondary: #161616 !important;
        --deprecated-card-bg: #161616 !important;
        --deprecated-store-bg: #161616 !important;
        --background-floating: #161616 !important;
        --bg-overlay-1: #161616 !important;
        --bg-overlay-2: #161616 !important;
        --bg-overlay-3: #161616 !important;
        --bg-overlay-4: #161616 !important;
        --bg-overlay-5: #161616 !important;
        --bg-overlay-6: #161616 !important;
        --bg-base: #161616 !important;
        --bg-primary: #161616 !important;
        --bg-secondary: #161616 !important;
      }

      .appMount-2yBXZl,
      .app-2CXKsg,
      .bg-1QIAus,
      .container-1eFtFS,
      .wrapper-3HVHpV,
      .scroller-3X7KbA,
      .layer-86YKbF,
      .container-2cd8Mz,
      .chat-2ZfjoI,
      .container-2o3qEW,
      .applicationStore-2nk7Lo,
      .pageWrapper-2PwDoS,
      .standardSidebarView-E9Pc3j,
      .contentRegion-3HkfJJ {
        background-color: #161616 !important;
      }

      body {
        --font: "JetBrains Mono";
        --code-font: "JetBrains Mono";
        font-weight: 300;
        letter-spacing: -0.05ch;

        --gap: 12px;
        --divider-thickness: 4px;
        --border-thickness: 2px;
        --border-hover-transition: 0.2s ease;

        --animations: on;
        --list-item-transition: 0.2s ease;
        --dms-icon-svg-transition: 0.4s ease;

        --top-bar-height: var(--gap);
        --top-bar-button-position: titlebar;
        --top-bar-title-position: off;
        --subtle-top-bar-title: off;

        --custom-window-controls: off;
        --window-control-size: 14px;

        --custom-dms-icon: off;
        --dms-icon-svg-url: url("");
        --dms-icon-svg-size: 90%;
        --dms-icon-color-before: var(--base03);
        --dms-icon-color-after: var(--base05);
        --custom-dms-background: off;

        --background-image: off;
        --background-image-url: url("");
        --transparency-tweaks: off;
        --remove-bg-layer: off;
        --panel-blur: off;
        --blur-amount: 12px;

        --bg-floating: var(--base00);
        --small-user-panel: on;
        --unrounding: on;
        --custom-spotify-bar: on;
        --ascii-titles: on;
        --ascii-loader: system24;

        --panel-labels: on;
        --label-color: var(--base04);
        --label-font-weight: 500;

        background-color: var(--base00) !important;
      }

      :root {
        /* Base16 Oxocarbon Dark Theme from shaunsingh/IBM */
        --base00: #161616; /* Background */
        --base01: #1f1f1f; /* Panels */
        --base02: #2a2a2a; /* Selections / overlays */
        --base03: #555555; /* Comments / borders */
        --base04: #838383; /* Secondary text */
        --base05: #bbbbbb; /* Primary text */
        --base06: #dfdfdf; /* Bright text */
        --base07: #ffffff; /* Brightest text */
        --base08:rgb(100, 154, 85); /* Red / errors */
        --base09: #df5a4f; /* Orange / warnings */
        --base0A: #ff9f43; /* Yellow / highlights */
        --base0B: rgb(100, 154, 85); /* Green / success */
        --base0C: #0db9d7; /* Cyan / info */
        --base0D: #0f7ddb; /* Blue / primary */
        --base0E: #C85C5C; /* MAIN Accent */
        --base0F: #C85C5C; /* Pink / special */

        /* Text mappings */
        --text-1: var(--base04);
        --text-2: var(--base04);
        --text-3: var(--base05);
        --text-muted: var(--base04);

        /* Backgrounds */
        --bg-1: var(--base00);
        --bg-2: var(--base00);
        --bg-3: var(--base00);
        --bg-4: var(--base00);
        --bg-overlay: var(--base00);
        --bg-app: var(--base00);
        --bg-base: var(--base00);
        --bg-primary: var(--base00);
        --background-primary: var(--base00);
        --background-secondary: var(--base00);
        --background-secondary-alt: var(--base00);
        --background-tertiary: var(--base00);
        --background-accent: var(--base0E);
        --background-modifier-hover: var(--base01);
        --background-modifier-active: var(--base02);
        --background-modifier-selected: var(--base02);
        --background-floating: var(--base01);

        /* UI states */
        --hover: rgba(160, 116, 196, 0.06);
        --active: rgba(160, 116, 196, 0.12);
        --active-2: rgba(160, 116, 196, 0.15);
        --message-hover: var(--hover);

        /* Accents */
        --accent-1: var(--base0C);
        --accent-2: var(--base0B);
        --accent-3: var(--base0E);
        --accent-4: var(--base0E);
        --accent-5: var(--base0F);

        /* Mentions & replies */
        --mention: linear-gradient(to right, rgba(223, 90, 79, 0.08) 40%, transparent);
        --mention-hover: linear-gradient(to right, rgba(223, 90, 79, 0.12) 40%, transparent);
        --reply: linear-gradient(to right, rgba(244, 56, 65, 0.06) 40%, transparent);
        --reply-hover: linear-gradient(to right, rgba(244, 56, 65, 0.1) 40%, transparent);

        /* Presence indicators */
        --online: var(--base0B);
        --dnd: var(--base08);
        --idle: var(--base09);
        --streaming: var(--base0E);
        --offline: var(--base03);

        /* Borders */
        --border: var(--base0E);
        --border-hover: var(--base0E);
        --button-border: var(--base0E);

        /* Color variants */
        --red-1: #f4a2a4;
        --red-2: var(--base08);
        --red-3: #c2363a;
        --red-4: #992d2f;
        --red-5: #7d2226;

        --green-1: #77c88a;
        --green-2: var(--base0B);
        --green-3: #37954f;
        --green-4: #2a7641;
        --green-5: #1d562d;

        --blue-1: #7fb4f8;
        --blue-2: var(--base0D);
        --blue-3: #3f6dcc;
        --blue-4: #2d4a8b;
        --blue-5: #1d3264;

        --purple-1: var(--base0E);
        --purple-2: var(--base0E);
        --purple-3: #825db8;
        --purple-4: #6e47a2;
        --purple-5: #583b88;

        --yellow-1: #f6d97a;
        --yellow-2: var(--base0A);
        --yellow-3: #cca644;
        --yellow-4: #a67f33;
        --yellow-5: #7d5f24;
      }

    '';
  };
}
