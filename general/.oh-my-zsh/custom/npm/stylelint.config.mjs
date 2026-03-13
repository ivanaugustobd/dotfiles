/** @type {import("stylelint").Config} */
export default {
  extends: [
    "stylelint-config-standard",
  ],
  plugins: [
    "stylelint-order",
  ],
  overrides: [
    {
      files: ["**/*.less"],
      extends: ["stylelint-config-standard-less"],
    },
    {
      files: ["**/*.scss"],
      extends: ["stylelint-config-standard-scss"],
      rules: {
        "scss/dollar-variable-pattern": null,
      }
    },
  ],
  rules: {
    "selector-class-pattern": null,
    "order/properties-alphabetical-order": true,
  },
}
