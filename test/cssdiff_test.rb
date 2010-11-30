require 'rubygems'
require 'csspool'
require 'test/unit'
require 'cssdiff'

module CSSDiff

  class CSSDiffTest < Test::Unit::TestCase
    def setup
      @doc1 = <<-EOCSS
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

      @doc2 = <<-EOCSS
      .ui-jqgrid .ui-jqgrid-titlebar{
          padding: 0.4em 0.2em 0.3em 0.3em;
      }

      .ui-jqgrid table{
          border-collapse: inherit;
          border-spacing:inherit;
      }
      EOCSS
      
      @result = CSSPool.CSS <<-EOCSS
      .ui-jqgrid tr.jqgrow td, .ui-jqgrid-htable tr th{
          border-bottom: 1px solid #E0EDA8;
          border-right: 1px solid #E0EDA8;
      }
      EOCSS
    end
    
    def test_compare_strings
      compare = CSSDiff.compare(@doc1, @doc2)
      assert_equal @result.to_s, compare
    end
    
    def test_compare_files
      file1 = open('fixtures/doc1.css')
      file2 = open('fixtures/doc2.css')
      compare = CSSDiff.compare_files(file1, file2)
      assert_equal @result.to_s, compare
    end
    
    def test_compare_dirs
      dir1 = Dir.glob('fixtures/dir1/*.css')
      dir2 = Dir.glob('fixtures/dir2/*.css')
      compare = CSSDiff.compare_dirs(dir1, dir2)
      assert_equal @result.to_s, compare
    end
    
  end  
end