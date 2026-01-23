const { withFaust } = require("@faustwp/core");

/**
 * @type {import('next').NextConfig}
 **/
module.exports = withFaust({
  images: {
    domains: [
      "faustexample.wpengine.com",
      "jubilant-space-lamp-g7xj6p9xpr39jp5-3001.app.github.dev",
      "localhost",
    ],
  },
  trailingSlash: true,
});
