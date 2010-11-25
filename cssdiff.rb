require 'rubygems'
require 'csspool'

# Monkey-patch RuleSset to add simple equality operators which allows array comparisons.
# NOTE: we're only comparing .selectors
# TODO: we should really compare .declarations and .media as well
module CSSPool
  module CSS
    class RuleSet
      def eql? that
        that.selectors.to_s.eql? self.selectors.to_s
      end
      def hash
        self.selectors.to_s.hash
      end
    end
  end
end

doc1 = CSSPool.CSS <<-EOCSS
.ui-jqgrid table{
    border-collapse: inherit;
    border-spacing:inherit;
}

.ui-jqgrid .ui-jqgrid-titlebar{
    padding: 0.4em 0.2em 0.3em 0.3em;
}

.ui-jqgrid tr.jqgrow td, .ui-jqgrid-htable tr th{
    border-bottom: 1px solid #E0EDA8;
    border-right: 1px solid #E0EDA8;
}
EOCSS

doc2 = CSSPool.CSS <<-EOCSS
.ui-jqgrid .ui-jqgrid-titlebar{
    padding: 0.4em 0.2em 0.3em 0.3em;
}

.ui-jqgrid table{
    border-collapse: inherit;
    border-spacing:inherit;
}
EOCSS

# Find the difference between our two rule_sets
puts (doc1.rule_sets | doc2.rule_sets) - (doc1.rule_sets & doc2.rule_sets)
