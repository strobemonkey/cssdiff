require 'rubygems'
require 'csspool'

# Monkey-patch RuleSet to add simple equality operators which allows array comparisons.
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

module CSSDiff
  def CSSDiff.compare doc1, doc2
    doc1 = CSSPool.CSS doc1
    doc2 = CSSPool.CSS doc2
    
    rs1 = doc1.rule_sets
    rs2 = doc2.rule_sets

    # Find the difference between the two rule_sets
    # Union subtract intersect
    result = (rs1 | rs2) - (rs1 & rs2)
    result.to_s
  end
  def CSSDiff.compare_files file1, file2
    doc1 = file1.read
    doc2 = file2.read
    CSSDiff.compare(doc1, doc2)
  end
end
