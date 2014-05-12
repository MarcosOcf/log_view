module LogView
  module Colors
    COLOR_CODES = {
      green:      32,
      red:        31,
      blue:       34,
      yellow:     33,
      light_blue: 36,
      pink:       35
    }
    
    COLOR_CODES.each_pair do |color, code|
      define_method("paint_#{color}") { |string|
        paint code, string
      }
    end

    def paint color_code, string
      "\e[#{color_code}m#{string}\e[0m"
    end

  end
end