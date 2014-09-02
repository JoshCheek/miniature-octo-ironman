Overview
--------

I want to be able to make ruby-monk style lessons
e.g. https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/44-collections/lessons/98-iterate-filtrate-and-transform
This project is to support that.

Getting started
---------------

<table>
  <tr>
    <td> Install dependencies with </td>
    <td> <code>rake bootstrap</code> </td>
  </tr>
  <tr>
    <td> Run tests with </td>
    <td> <code>rake cuke</code> </td>
  </tr>
  <tr>
    <td> Run server with </td>
    <td> <code>rake server</code> (once someone does <a href="https://github.com/JoshCheek/miniature-octo-ironman/issues/11"> Rake task for server</a> anyway) </td>
  </tr>
</table>

Iteration 1 goals
-----------------

- [ ] I can embed a Ruby snippet into a markdown page and see an editor
- [ ] I can run the code in the editor and see the output (Follow along with progress at #12)

How do I contribute?
--------------------

* Pick an [issue](https://github.com/JoshCheek/miniature-octo-ironman/issues):
  * Look for one that is not assigned
  * Sub issues of [#12][issue12] would be super helpful :)
  * Also, [#2][issue2], [#11][issue11], and [#17][issue17] are small
* Try to work in small steps that you can push up to master without breaking tests
* Make sure any relevant behaviour is tested, so we don't break your shit when we change it (we'll do the same for you, so you can change our shit without fear)
* In any relevant commits, mention the issue number (e.g. [#17](issue17)), they will automatically be associated with the issue ([more on linking](https://help.github.com/articles/writing-on-github#references))
* When your commits are adequate to complete your story, ask for a code review.

Philosophy of collaboration
---------------------------

* Change anything you want (try to understand why it is the way it is, ask others if you need context)
* Try to work in small enough steps that you can push them multiple times per day (ideally, you can push after each commit, though you don't necessarily)
* Everyone's local master should be hovering around origin/master so that all changes are small with low likelihood of conflict, and everyone has as much of everyone else's work as possible, so that no one is being held up by unmerged features.
* Have reasonable tests on your features so we know if we break them. If you're having difficulty knowing what or how to do this, come ask.
* Never push failing tests to master, you'll break everyone else's ability to work on their thing, they'll have to deal with your failure.
* See a problem? Fix it. Have an idea? Open an issue.

Future shit maybe
-----------------

* manifest of lesson names to git repositories (ie gist) rather than having to edit the source of the server to change a lesson
* maybe scoped by content owner
* maybe overridable language for the editor


[issue2]:  https://github.com/JoshCheek/miniature-octo-ironman/issues/2
[issue11]: https://github.com/JoshCheek/miniature-octo-ironman/issues/11
[issue12]: https://github.com/JoshCheek/miniature-octo-ironman/issues/12
[issue17]: https://github.com/JoshCheek/miniature-octo-ironman/issues/17

