import { QuartzTransformerPlugin } from "../types"
import { Root, Code } from "mdast"
import { visit } from "unist-util-visit"
import { CSSResource } from "../../util/resources"

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;")
}

interface Options {
  poetryFont?: string
  enablePoetryBlocks?: boolean
}

const defaultOptions: Options = {
  poetryFont: "'Georgia', 'Times New Roman', serif",
  enablePoetryBlocks: true,
}

export const Poetry: QuartzTransformerPlugin<Partial<Options>> = (userOpts) => {
  const opts = { ...defaultOptions, ...userOpts }

  return {
    name: "Poetry",
    markdownPlugins() {
      if (!opts.enablePoetryBlocks) {
        return []
      }

      return [
        () => {
          return (tree: Root, file) => {
            visit(tree, "code", (node: Code) => {
              if (node.lang === "poetry") {
                file.data.hasPoetry = true

                const poetryLines = node.value.split("\n")
                const linesHtml = poetryLines
                  .map((line) => line.trim() === "" ? `<span class="poetry-line poetry-blank-line">&nbsp;</span>` : `<span class="poetry-line">${escapeHtml(line)}</span>`)
                  .join("\n")

                Object.assign(node, {
                  type: "html",
                  value: `<div class="poetry-block" data-poetry-font="${opts.poetryFont}">${linesHtml}</div>`,
                })
              }
            })
          }
        },
      ]
    },
    externalResources() {
      const css: CSSResource[] = []

      if (opts.enablePoetryBlocks) {
        const fontName = opts.poetryFont?.replace(/['"]/g, "").split(",")[0].trim()
        if (
          fontName &&
          !["Georgia", "Times New Roman", "serif", "sans-serif", "monospace"].includes(fontName)
        ) {
          const googleFontName = fontName.replace(/\s+/g, "+")
          css.push({
            content: `@import url('https://fonts.googleapis.com/css2?family=${googleFontName}:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap');`,
            inline: true,
          })
        }

        css.push({
          content: `
.poetry-block {
  font-family: var(--poetry-font, ${opts.poetryFont});
  line-height: 1.6;
  margin: 1.5rem 0;
  padding: 1rem;
  border-left: 3px solid var(--secondary);
  background-color: var(--lightgray);
  border-radius: 5px;
}

.poetry-line {
  display: block;
  margin-bottom: 0.25rem;
  text-indent: 0;
  hanging-indent: 2em;
  padding-left: 2em;
  text-indent: -2em;
}

.poetry-line:last-child {
  margin-bottom: 0;
}

/* Responsive adjustments for mobile */
@media (max-width: 768px) {
  .poetry-block {
    padding: 0.75rem;
    margin: 1rem 0;
  }
  
  .poetry-line {
    hanging-indent: 1.5em;
    padding-left: 1.5em;
    text-indent: -1.5em;
  }
}

/* Custom property for font customization */
:root {
  --poetry-font: ${opts.poetryFont};
}

/* Dark mode adjustments */
[saved-theme="dark"] .poetry-block {
  background-color: var(--dark);
  border-left-color: var(--secondary);
}
          `,
          inline: true,
        })
      }

      return { css }
    },
  }
}

declare module "vfile" {
  interface DataMap {
    hasPoetry: boolean | undefined
  }
}