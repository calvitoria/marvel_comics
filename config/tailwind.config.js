const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('daisyui')
  ],
  daisyui: {
    themes: [
      "dark",
      "retro",
      "lofi",
      "dracula",
      "cmyk"
    ],
  }
}
