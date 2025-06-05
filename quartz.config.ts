import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

/**
 * Quartz 4 Configuration
 *
 * See https://quartz.jzhao.xyz/configuration for more information.
 */
const config: QuartzConfig = {
  configuration: {
    pageTitle: "The Quotidian",
    pageTitleSuffix: " - The Quotidian, by Simon Kenny",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: 'goatcounter',
      websiteId: 'simonkenny-co',
      host: 'analytics.enchiridion.xyz',
      scriptSrc: 'https://analytics.enchiridion.xyz/count.js'
    },
    locale: "en-US",
    baseUrl: "simonkenny.co",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "modified",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
      typography: {
        title: "Cormorant",
        header: "Yeseva One",
        body: "Crimson Pro",
        code: "Anonymous Pro",
      },
      colors: {
        lightMode: {
          light: "#fffef7", // Warm newsprint white
          lightgray: "#f7f5f2", // Subtle cream background
          gray: "#a3a096", // Muted olive-gray
          darkgray: "#4a453e", // Rich charcoal brown
          dark: "#1a1815", // Deep ink black
          secondary: "#8b5a3c", // Sophisticated copper-brown
          tertiary: "#c4956c", // Warm tan accent
          highlight: "rgba(139, 90, 60, 0.06)", // Subtle brown wash
          textHighlight: "#f4e5d3", // Aged paper highlight
        },
        darkMode: {
          light: "#1c1a17", // Rich dark brown-black
          lightgray: "#2a2722", // Layered brown surface
          gray: "#6b645c", // Warm neutral
          darkgray: "#c7c0b8", // Warm light gray
          dark: "#f5f2ee", // Soft cream text
          secondary: "#d4a574", // Golden tan
          tertiary: "#b8956f", // Muted gold accent
          highlight: "rgba(212, 165, 116, 0.08)", // Warm gold glow
          textHighlight: "#3d2f1f", // Rich sepia highlight
        },
      },
    }
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["frontmatter", "git", "filesystem"],
      }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({
        markdownLinkResolution: "shortest",
        openLinksInNewTab: true,
      }),
      Plugin.Description(),
      Plugin.Latex({ renderEngine: "katex" }),
      Plugin.Poetry({
        poetryFont: "'Cormorant Garamond'",
      }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.Favicon(),
      Plugin.NotFoundPage(),
      // Comment out CustomOgImages to speed up build time
      Plugin.CustomOgImages(),
    ],
  },
}

export default config
