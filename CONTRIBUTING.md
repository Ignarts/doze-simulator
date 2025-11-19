# Contributing to Doze Simulator

First off, thanks for taking the time to contribute! 🎉

The following is a set of guidelines for contributing to `doze-simulator`. These are mostly guidelines, not rules. Use your best judgment and feel free to propose changes to this document in a pull request.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps to reproduce the problem** in as much detail as possible.
- **Include details about your environment**:
    - OS (macOS, Linux, WSL)
    - Android device model and OS version
    - `adb` version

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as much detail as possible.
- **Explain why this enhancement would be useful** to most users.

### Pull Requests

1.  Fork the repo and create your branch from `main`.
2.  If you've added code that should be tested, add tests.
3.  Ensure the test suite passes.
4.  Make sure your code follows the existing style (we use `shellcheck` for the script).
5.  Issue that pull request!

## Styleguides

### Shell Script

- We use [ShellCheck](https://www.shellcheck.net/) to ensure script quality.
- Please use `printf` instead of `echo` for portability where possible.
- Use 2 spaces for indentation.

## License

By contributing, you agree that your contributions will be licensed under its MIT License.
