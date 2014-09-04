Feature: Document with code that prints output

  I want rubymonk style lessons

  Scenario:
    Given I have a document "lesson1.md":
    """
    Hey, here's how to use size

    <div class="interactive-code">
      p ['a', 'b', 'c']
    </div>
    """
    When I visit "/lesson1"
    Then my page has "how to use size" on it
    And my page has an editor with "puts ['a', 'b', 'c'].size"
    When I submit the code in editor 1
    Then I see an output box with "a\nb\nc" in it
