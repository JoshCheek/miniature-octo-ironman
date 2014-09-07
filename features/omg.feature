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
