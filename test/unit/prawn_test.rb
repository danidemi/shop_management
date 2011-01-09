require 'test_helper'
require 'tmpdir'

class PrawnTest < ActiveSupport::TestCase
  
  def path_for_file(file)
    Dir.tmpdir + "/" + file
  end

  test "how to generate a worksheet using procedural style" do

    # build table model
    rows = Array.new()
    rows << ["Time", "Operator 1", "Operator 2", "Operator 3"]
    rows << ["09:00 - 09:30", [["Jean hair"],["hair"]], "",""]
    rows << ["09:30 - 10:00", "", [["Jean hair"],["hair"]],""]
    rows << ["10:00 - 10:30", "", "",[["Jean hair"],["hair"]]]
    rows << ["10:30 - 11:00", "", "",""]

    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)

    puts "bottom bound:#{pdf.bounds.absolute_bottom}"
    puts "top bounds:#{pdf.bounds.absolute_top}"
    puts "left bounds:#{pdf.bounds.absolute_left}"
    puts "right bounds:#{pdf.bounds.absolute_right}"

    pdf_rows = rows.collect do |a_row|
      a_row.collect do |a_cell|
        puts "formatting cell #{a_cell.inspect}"
        if(a_cell.kind_of? Array)
          pdf.make_table(a_cell, :header => false)
        else
          a_cell
        end
      end
    end

    pdf.bounding_box([40,pdf.bounds.absolute_top - 40], :width => pdf.bounds.width) do
      pdf.text "Meetings for 10/20/2010"
    end

    pdf.bounding_box([40,pdf.bounds.absolute_top - 80], :width => pdf.bounds.width) do
      pdf.make_table(pdf_rows, :header => true, :cell_style => {:padding => 10}) { |table|
      }.draw
    end

    pdf.render_file path_for_file("worksheet_procedural.pdf")
  end

  test "how to generate a worksheet using blocks" do

    # build table model
    rows = Array.new()
    rows << ["", "Operatore 1", "Operatore 2", "Operatore 3"]
    #    rows << ["09:00 - 09:30", "Gianna x capelli", "",""]
    #    rows << ["09:30 - 10:00", "", "Paola x capelli",""]
    #    rows << ["10:00 - 10:30", "", "","Susanna x capelli"]
    rows << ["09:00 - 09:30", ["Gianna Coccardini", "x capelli"], "",""]
    rows << ["09:30 - 10:00", "", ["Gianna Coccardini", "x capelli"],""]
    rows << ["10:00 - 10:30", "", "",["Gianna Coccardini", "x capelli"]]
    rows << ["10:30 - 11:00", "", "",""]

    #draw table
    Prawn::Document.generate path_for_file("worksheet.pdf") do |pdf|

      pdf_rows = rows.collect do |a_row|
        pdf_row = a_row.collect do |a_cell|
          puts "formatting cell #{a_cell.inspect}"
          if(a_cell.kind_of? Array)
            Prawn::Table.new([a_cell], pdf)
          else
            a_cell
          end
        end
      end


      pdf.table(pdf_rows, :cell_style => { :padding => 12 }) do |ws|
        #        ws.cells.borders = []
        #        ws.style row(0), :border_width => 2, :borders => [:bottom]
        #        ws.style(columns(0)) { |cell| cell.borders |= [:right] }
      end
    end
  end

  test "how to generate a table" do
    Prawn::Document.generate path_for_file("table.pdf") do

      table([["foo", "bar " * 15, "baz"],
          ["baz", "bar", "foo " * 15]], :cell_style => { :padding => 12 }) do
        cells.borders = []

        # Use the row() and style() methods to select and style a row.
        style row(0), :border_width => 2, :borders => [:bottom]

        # The style method can take a block, allowing you to customize properties
        # per-cell.
        style(columns(0..1)) { |cell| cell.borders |= [:right] }
      end

      move_down 12

      table([%w[foo bar bazbaz], %w[baz bar foofoo]],
        :cell_style => { :padding => 12 }, :width => bounds.width)

    end
  end


  test "should produce a pdf" do
    Prawn::Document.generate path_for_file("temp.pdf") do
      fill_color "0000ff"
      draw_text "Hello World", :at => [200,420], :size => 32, :rotate => 45
      font "Times-Roman"
      fill_color "ff0000"
      draw_text "Using Another Font", :at => [5,5]
      start_new_page
      font "Courier"
      draw_text "Goodbye World", :at => [288,50]
    end
  end

end
