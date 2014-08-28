Overview
--------

I want to be able to make ruby-monk style lessons
e.g. https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/44-collections/lessons/98-iterate-filtrate-and-transform
This project is to support that.

Workflow
--------

After we explore a bit:

* pull from issues
* make a branch to implement the feature
* send pull request
* after code review, merge it

Getting started
---------------

Install dependencies with

```sh
rake bootstrap
```

Run tests with

```sh
rake cuke
```

Main areas
----------

* Evaluate code safely with (http://rubygems.org/gems/eval_in)
* Get a Js editor at (https://duckduckgo.com/?q=ace+editor)
* Server: [Rack](http://rubygems.org/gems/rack) / [Sinatra](http://rubygems.org/gems/sinatra) / [Rails](http://rubygems.org/gems/rails)


Future shit maybe
-----------------

* manifest of lesson names to git repositories (ie gist) rather than having to edit the source of the server to change a lesson
* maybe scoped by content owner
* maybe overridable language for the editor

Iteration 1 goals
-----------------

* I can embed a Ruby snippet into a markdown page and see an editor
* I can run the code in the editor and see the output


Other shit I wrote down
-----------------------

```
Feature: Document with code that prints output
  I want rubymonk style lessons

  Scenario:
    Given I have a document "lesson1.md":
    """
    Hey, here's how to use size

    <div class="interactive-code">
      puts ['a', 'b', 'c'].size
    </div>
    """
    When I visit "/lesson1"
    Then my page has "how to use size" on it
    And my page has an editor with "puts ['a', 'b', 'c'].size"
    When I submit the code in editor 1
    Then I see an output box with "3" in it

Client
  javascript lib that pulls out some sort of tag maybe
      <div class="editor">
        <div class="initial-content">
          def sort(array)
            array.each do
              array.each_index.each_cons(2).each do |prev_index, current_index|
                prev, current = array[prev_index], array[current_index]
                if current < prev
                  array[prev_index], array[current_index] = current, prev
                end
              end
            end
          end
        </div>
        <div class="test-suite">
          require 'minitest/autorun'
          class SortTest < Minitest::Test
            def test_it_sorts_an_empty_array
              assert_equal [], sort([])
            end

            def test_it_sorts_an_array
              assert_equal [1,2,3], sort([1,2,3])
              assert_equal [1,2,3], sort([2,1,3])
              assert_equal [1,2,3], sort([1,3,2])
              assert_equal [1,2,3], sort([3,1,2])
              assert_equal [1,2,3], sort([2,3,1])
              assert_equal [1,2,3], sort([3,2,1])
            end
          end
        </div>
        <div class="display" data-type="minitest-output">
      </div>

  so maybe it pulls that tag out and places an editor window in place
    http://ace.c9.io/#nav=about
  then has a "run" button or something
    takes the code and test, submits to the server, server evals it, hands back JSON result
  or maybe the code and content are kept separate, idk

Server
  serving initial file
    receives the request
    generates the html file
      lets assume I'm writing markdown
      how do we store this?
    serves it up
      (renders it, embeds links to stylesheets and javascripts)
  serving requests
    receives the request (in above example, the code and the test suite)
    evaluates the code somehow (should it be aware of evaluation styles?)
    returns the JSON result
```
