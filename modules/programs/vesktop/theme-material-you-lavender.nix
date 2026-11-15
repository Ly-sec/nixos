{
  flake.modules.homeManager."vesktop" = {
    config,
    pkgs,
    ...
  }: {
    home.file.".config/vesktop/themes/material-you-lavender.theme.css".text = ''
      /**
      * @name Material You Lavender-Gold
      * @description A Base16-aligned theme based on your Material You color scheme
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

      /* Force Material You background everywhere */
      .theme-dark,
      .theme-light,
      :root {
        --background-primary: var(--base00) !important;
        --background-secondary: var(--base01) !important;
        --background-secondary-alt: var(--base01) !important;
        --background-tertiary: var(--base02) !important;
        --background-mobile-primary: var(--base00) !important;
        --background-mobile-secondary: var(--base01) !important;
        --deprecated-card-bg: var(--base01) !important;
        --deprecated-store-bg: var(--base01) !important;
        --background-floating: var(--base01) !important;
        --bg-overlay-1: var(--base01) !important;
        --bg-overlay-2: var(--base02) !important;
        --bg-overlay-3: var(--base02) !important;
        --bg-overlay-4: var(--base02) !important;
        --bg-overlay-5: var(--base02) !important;
        --bg-overlay-6: var(--base02) !important;
        --bg-base: var(--base00) !important;
        --bg-primary: var(--base00) !important;
        --bg-secondary: var(--base01) !important;
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
        background-color: var(--base00) !important;
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
        /* Base16 Material You Lavender-Gold Theme */
        --base00: #0C0D11; /* Background Primary */
        --base01: #151720; /* Background Secondary */
        --base02: #1D202B; /* Background Tertiary */
        --base03: #44485A; /* Outline */
        --base04: #6B718A; /* Text Disabled */
        --base05: #B7BBD0; /* Text Secondary */
        --base06: #CACEE2; /* Text Primary */
        --base07: #E3C2FF; /* Highlight */
        --base08: #FF6B81; /* Error */
        --base09: #FFBB66; /* Warning */
        --base0A: #8EABFF; /* Accent Tertiary */
        --base0B: #A8AEFF; /* Accent Primary */
        --base0C: #9EA0FF; /* Accent Secondary */
        --base0D: #F3DEFF; /* Ripple Effect */
        --base0E: #A8AEFF; /* Main Accent */
        --base0F: #2A2D3A; /* Surface Variant */

        /* Text mappings */
        --text-1: var(--base04);
        --text-2: var(--base04);
        --text-3: var(--base05);
        --text-muted: var(--base04);

        /* Backgrounds */
        --bg-1: var(--base00);
        --bg-2: var(--base01);
        --bg-3: var(--base02);
        --bg-4: var(--base02);
        --bg-overlay: var(--base00);
        --bg-app: var(--base00);
        --bg-base: var(--base00);
        --bg-primary: var(--base00);
        --background-primary: var(--base00);
        --background-secondary: var(--base01);
        --background-secondary-alt: var(--base01);
        --background-tertiary: var(--base02);
        --background-accent: var(--base0E);
        --background-modifier-hover: var(--base01);
        --background-modifier-active: var(--base02);
        --background-modifier-selected: var(--base02);
        --background-floating: var(--base01);

        /* UI states */
        --hover: rgba(168, 174, 255, 0.06);
        --active: rgba(168, 174, 255, 0.12);
        --active-2: rgba(168, 174, 255, 0.15);
        --message-hover: var(--hover);

        /* Accents */
        --accent-1: var(--base0C);
        --accent-2: var(--base0B);
        --accent-3: var(--base0E);
        --accent-4: var(--base0E);
        --accent-5: var(--base0F);

        /* Mentions & replies */
        --mention: linear-gradient(to right, rgba(255, 107, 129, 0.08) 40%, transparent);
        --mention-hover: linear-gradient(to right, rgba(255, 107, 129, 0.12) 40%, transparent);
        --reply: linear-gradient(to right, rgba(168, 174, 255, 0.06) 40%, transparent);
        --reply-hover: linear-gradient(to right, rgba(168, 174, 255, 0.1) 40%, transparent);

        /* Presence indicators */
        --online: var(--base0B);
        --dnd: var(--base08);
        --idle: var(--base09);
        --streaming: var(--base0E);
        --offline: var(--base03);

        /* Borders */
        --border: var(--base03);
        --border-hover: var(--base0E);
        --button-border: var(--base03);

        /* Color variants */
        --red-1: #ffb3c1;
        --red-2: var(--base08);
        --red-3: #e04d65;
        --red-4: #b83a50;
        --red-5: #8f2a3d;

        --green-1: #c5c7ff;
        --green-2: var(--base0B);
        --green-3: #8e90e6;
        --green-4: #6b6dc7;
        --green-5: #4e50a1;

        --blue-1: #b8d1ff;
        --blue-2: var(--base0A);
        --blue-3: #6b8be6;
        --blue-4: #4a6ac7;
        --blue-5: #324da1;

        --purple-1: var(--base0E);
        --purple-2: var(--base0E);
        --purple-3: #8e90e6;
        --purple-4: #6b6dc7;
        --purple-5: #4e50a1;

        --yellow-1: #ffd699;
        --yellow-2: var(--base09);
        --yellow-3: #e6a04d;
        --yellow-4: #c7833a;
        --yellow-5: #a1692a;
      }

      /* Additional customizations for better Material You integration */
      .theme-dark .root-1CAIjD,
      .theme-dark .container-1D34oG {
        background-color: var(--base00) !important;
      }

      /* Message bubbles */
      .theme-dark .message-2CShn3 {
        background-color: var(--base01) !important;
        border-radius: 8px;
      }

      /* Input area */
      .theme-dark .channelTextArea-1FufC0 {
        background-color: var(--base01) !important;
      }

      /* Server list */
      .theme-dark .guilds-2JjMmN {
        background-color: var(--base00) !important;
      }

      /* User area */
      .theme-dark .panels-3wFtMD {
        background-color: var(--base00) !important;
      }

      /* Better contrast for buttons */
      .button-1EGGcP {
        background-color: var(--base01) !important;
        color: var(--base06) !important;
      }

      .button-1EGGcP:hover {
        background-color: var(--base02) !important;
      }

      /* Spotify controls */
      .spotify-button {
        color: var(--base0B) !important;
      }

      /* Scrollbars */
      .theme-dark ::-webkit-scrollbar-thumb {
        background-color: var(--base03) !important;
      }
    '';
  };
}
