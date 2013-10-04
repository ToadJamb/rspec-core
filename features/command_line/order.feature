Feature: --order (new in rspec-core-2.8)

  Use the `--order` option to tell RSpec how to order the files, groups, and
  examples. Options are `defined` and `rand`:

  `defined` is the default, which executes groups and examples in the
  order they are defined as the spec files are loaded.

  Use `rand` to randomize the order of groups and examples within groups.*

  * Nested groups are always run from top-level to bottom-level in order to avoid
    executing `before(:all)` and `after(:all)` hooks more than once, but the order
    of groups at each level is randomized.

  You can also specify a seed:

  <h3>Examples</h3>

      --order defined
      --order rand
      --order rand:123
      --seed 123 # same as --order rand:123

  The `defined` option is only necessary when you have `--order rand` stored in a
  config file (e.g. `.rspec`) and you want to override it from the command line.

  Scenario: defined order runs the test in the same sequence every time
    Given a file named "defined_order_spec.rb" with:
      """ruby
      describe 'specs that run in a defined order' do
        it('runs spec #1') {}
        it('runs spec #2') {}
        it('runs spec #3') {}
      end
      """
    When I run `rspec defined_order_spec.rb --order defined --format documentation`
    Then the output should contain:
      """
        runs spec #1
        runs spec #2
        runs spec #3
      """

  Scenario: specifying a seed with defined order does not randomize the spec sequence
    Given a file named "defined_order_spec.rb" with:
      """ruby
      describe 'specs that run in a defined order' do
        it('runs spec #1') {}
        it('runs spec #2') {}
        it('runs spec #3') {}
      end
      """
    When I run `rspec defined_order_spec.rb --order defined --seed 1 --format documentation`
    Then the output should contain:
      """
        runs spec #1
        runs spec #2
        runs spec #3
      """

  Scenario: order rand runs the test in a random sequence
    Given a file named "random_order_spec.rb" with:
      """ruby
      describe "specs that run in a random order" do
        it('runs spec #1') {}
        it('runs spec #2') {}
        it('runs spec #3') {}
      end
      """
    When I run `rspec random_order_spec.rb --order rand --format documentation`
    And I run `rspec random_order_spec.rb --order rand --format documentation`
    And I run `rspec random_order_spec.rb --order rand --format documentation`
    And I run `rspec random_order_spec.rb --order rand --format documentation`
    And I run `rspec random_order_spec.rb --order rand --format documentation`
    Then the output should match:
      """
      specs that run in a random order
        runs spec #[23]
        runs spec #[13]
        runs spec #[12]
      """
