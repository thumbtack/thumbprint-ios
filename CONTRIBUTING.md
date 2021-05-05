# Contributing to Thumbprint

The Design Systems team welcomes contributions from all developers at Thumbtack. These contributions can range from small bug reports to brand new components and initiatives.

Here are a few ways to get started:

## File a bug or request a feature

Providing feedback is the easiest way to contribute to Thumbprint. You can do this by [creating an issue on GitHub](https://github.com/thumbtack/thumbprint-ios/issues).

If you're a Thumbtack employee, you can also post on [#design-systems](https://thumbtack.slack.com/messages/C7FLM0ZGU/details/) for quick help.

## Contribute code to Thumbprint

There are two ways to contribute code back to Thumbprint:

1. **Tackle open GitHub issues:** Issues labeled as “[good first issue](https://github.com/thumbtack/thumbprint-ios/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)” or “[help wanted](https://github.com/thumbtack/thumbprint-ios/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22)” are perfect for contributors that want to tackle small tasks.
2. **Propose and create a new component:** Creating a component allows contributors to dive-deep into component API design, testing, accessibility, and documentation. Please [create a GitHub issue](https://github.com/thumbtack/thumbprint-ios/issues) to propose a new component. If the component is a good candidate for Thumbprint, we’ll schedule a kick-off meeting to discuss next steps.

### Submitting a pull request

Here are a few things to keep in mind when creating a pull request:

-   **Testing:** Run the Thumbrint scheme's test suite locally in Xcode to ensure that the build will pass. If any snapshot tests fail, set `recordMode = true` in the `setUp()` function of that test class, and re-run the test. Review the changes to the snapshots to ensure that they are intended and include them in the code review.

## Releasing a new version of Thumbprint

This will be done by a member of the Thumbtack iOS team when code has been merged and is ready for release.

1. **Update CocoaPod version:** Update `s.version` in `Thumbprint.podspec`. We follow [semantic versioning](https://semver.org/), so look at the changes that will be included in this release and increment it accordingly.
2. **Run Pod linter:** In the root directory of the repo, run `pod lib lint`. If there are any errors, resolve them before continuing with the release.
3. **Commit:** Commit the change you made in step 1 with the subject "Release <version>" (e.g., "Release 1.2.3"). Create and merge a pull request with this commit.
4. **Checkout main:** Return to the `main` branch and pull to get the commit you just merged.
5. **Tag release:** Run `git tag '<version>'` (e.g., `git tag '1.2.3'`) to tag this commit, and then run `git push --tags` to push the new tag.
6. **Create a new release in GitHub:** On the [Releases](https://github.com/thumbtack/thumbprint-ios/releases) page for the repo, click "Draft a new release". Set "Tag version" to the name of the tag you created in step 3 (e.g., `1.2.3`). Set "Release title" to the same value as the tag version. In the description field, give an overview of the changes going into this release. When all fields have been filled out, click "Publish release."
7. **Publish CocoaPod:** Run `pod trunk push Thumbprint.podspec`. If you get an error saying you are not authorized to publish this CocoaPod, ask one of the maintainers of the library to [add you as a contributor](https://guides.cocoapods.org/making/getting-setup-with-trunk#adding-other-people-as-contributors).

### Common release issues

`[!] Authentication token is invalid or unverified. Either verify it with the email that was sent or register a new session.`
- Run `pod trunk register <email> '<name>'` (e.g., `pod trunk register kevinb@thumbtack.com 'Kevin Beaulieu'`) and click the link in the verification email you receive. Then try running `pod trunk push Thumbprint.podspec` again.

`[!] You (<your-email>) are not allowed to push new versions for this pod. The owners of this pod are <owner-emails>.`
- Ask one of the owners to [add you as a contributor](https://guides.cocoapods.org/making/getting-setup-with-trunk#adding-other-people-as-contributors) by running `pod trunk add-owner Thumbprint <your-email>`.

---

As always, reach out to [#design-systems](https://thumbtack.slack.com/messages/C7FLM0ZGU/details/) (internal to Thumbtack employees) or [create an issue](https://github.com/thumbtack/thumbprint-ios/issues) if you have questions or feedback.
