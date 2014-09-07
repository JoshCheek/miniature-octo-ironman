Overview
--------

Currently hosted [here](http://turingschool-moi.herokuapp.com/lesson1).

I want to increase student engagement by embedding a runnable
Ruby editor in the middle of their lessons. Then I can place
interactive examples inline with the explanations. This idea
is inspired by the [ExplorableExplanations](http://worrydream.com/ExplorableExplanations/)
blog (even though Bret Victor would likely find this project inadequate).

![Example](example.gif)

Vision
------

For now, just match what rubymonks can do (run some code, show the output).
In the future, if I have time/energy/competence, maybe get the environment
to become considerably better. Here are things that entice me:

* Syntax awareness in the editor (e.g. mouse over the var, it says its a local var, shows where its defined, might be able to use [rsense](https://rsense.github.io/) for this)
* More interesting dynamic environments, e.g. [SiB](https://github.com/JoshCheek/seeing_is_believing), and test suites to check user submissions to challenges.
* Ability to render an image of the object model and see how it updates as the user steps through the code (basically, dynamic explorable version of my [ObjectModel talk](https://github.com/JoshCheek/ruby-object-model)).
* Support more sophisticated environments (e.g. gems) this will be difficult, though, without more control over the [executing environment](https://eval.in/) (maybe I can get added to that project)
* Support other languages (this is inherently doable, eval.in already supports many)

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

How do I contribute?
--------------------

* Pick an [issue](https://github.com/JoshCheek/miniature-octo-ironman/issues):
  * Look for one that is not assigned
* Try to work in small steps that you can push up to master without breaking tests
* Push to master as *often* as you can!
* Make sure any relevant behaviour is tested, so we don't break your shit when we change it (we'll do the same for you, so you can change our shit without fear)
* In any relevant commits, mention the issue number (e.g. [#17](https://github.com/JoshCheek/miniature-octo-ironman/issues/17)),
  they will automatically be associated with the issue ([more on linking](https://help.github.com/articles/writing-on-github#references))
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
