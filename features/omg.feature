Feature: Document with code that prints output

  I want rubymonk style lessons

  Scenario:
    Given eval.in will serve "https://eval.in/189571.json" as:
    """
      { "lang":          "ruby/mri-2.1",
        "lang_friendly": "Ruby — MRI 2.1",
        "code":          "\n  puts ['a', 'b', 'c'].size\n",
        "output":        "mock-from-cuke",
        "status":        "OK (0.052 sec real, 0.060 sec wall, 9 MB, 18 syscalls)"
      }
    """
    Given I have a document "lesson1.md":
    """
    Hey, here's how to use size

    <div class="interactive-code">
      puts ['z', 'o', 'm', 'g'].size
    </div>
    """
    When I visit "/lesson1"
    Then my page has "how to use size" on it
    And my page has an editor with "puts ['z', 'o', 'm', 'g'].size"
    When I submit the code in the editor
    Then I see an output box with "mock-from-cuke" in it

  Scenario:
    Given eval.in will serve "https://eval.in/189571.json" as:
    """
      { "lang":          "ruby/mri-2.1",
        "lang_friendly": "Ruby — MRI 2.1",
        "code":          "\n  puts ['a', 'b', 'c'].size\n",
        "output":        "mock-from-cuke",
        "status":        "OK (0.052 sec real, 0.060 sec wall, 9 MB, 18 syscalls)"
      }
    """
    And the git repo exists
    And I have a configuration
    And the git repo has the file "my-lesson.md"
    """
    I came from a git repo!

    <div class="interactive-code">
      1+1
    </div>
    """
    When I visit "/someowner/custom_lesson"
    Then my page has "I came from a git repo" on it
    And my page has the SHA from the repo
    And my page has an editor with "1+1"
    When I submit the code in the editor
    Then I see an output box with "mock-from-cuke" in it

  Scenario:
    Given I have a git repo
    When I visit "/endpoints/new"
    And I submit in the endpoint form with this repo's data
    Then my endpoint has been persisted to the server's json file
    When I visit the page holding this repo's main file
    Then I see the file from the repo
