# To assist in PDF document production
module Pdfdoc
  def self.draw_horizontal_line(pdf, line_color)
    pdf.stroke_color line_color

    pdf.stroke do
      pdf.move_down 10
      pdf.horizontal_line 0, 600
    end
  end
end
