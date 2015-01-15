require 'graphviz/core_ext'

class GraphViz
   module Utils
      class Colors
         HEX_FOR_COLOR = /[0-9a-fA-F]{2}/
         RGBA = /^(#{HEX_FOR_COLOR})(#{HEX_FOR_COLOR})(#{HEX_FOR_COLOR})(#{HEX_FOR_COLOR})?$/

         attr_reader :r, :g, :b, :a
         attr_reader :h, :s, :v

         def initialize
            @r, @g, @b, @a, @h, @s, @v, @color = nil, nil, nil, nil, nil, nil, nil, nil
         end

         def rgb(r, g, b, a = nil)
            if r.is_a?(Fixnum)
               r = r.to_s.convert_base(10, 16)
            end
            unless r.is_a?(String) and HEX_FOR_COLOR.match(r)
               raise ColorException, "Bad red value"
            end

            if g.is_a?(Fixnum)
               g = g.to_s.convert_base(10, 16)
            end
            unless g.is_a?(String) and HEX_FOR_COLOR.match(g)
               raise ColorException, "Bad green value"
            end

            if b.is_a?(Fixnum)
               b = b.to_s.convert_base(10, 16)
            end
            unless b.is_a?(String) and HEX_FOR_COLOR.match(b)
               raise ColorException, "Bad blue value"
            end

            if a.is_a?(Fixnum)
               a = a.to_s.convert_base(10, 16)
            end
            unless a.nil? or (a.is_a?(String) and HEX_FOR_COLOR.match(a))
               raise ColorException, "Bad alpha value"
            end

            @r = r
            @g = g
            @b = b
            @a = a

            @color = COLORS.key(rgba_string.downcase)

            @h, @s, @v = rgb_to_hsv(@r, @g, @b)
         end

         def hsv(h, s, v)
            unless h.is_a?(Float) and s.is_a?(Float) and v.is_a?(Float)
               raise ColorException, "Bas HSV value"
            end

            @h = h
            @s = s
            @v = v

            @r, @g, @b = hsv_to_rgb(@h, @s, @v)

            @color = COLORS.key(rgba_string.downcase);
         end

         def name(c = nil)
            return @color if c.nil?

            @color = c

            rgb = COLORS[c]
            unless rgb.nil?
               m = RGBA.match(rgb)
               @r = m[1]
               @g = m[2]
               @b = m[3]

               @h, @s, @v = rgb_to_hsv(@r, @g, @b)
            end
         end

         def rgba_string(c = "")
            unless @r.nil?
               "#{c}#{@r}#{@g}#{@b}#{((@a.nil?)?"":@a)}"
            else
               nil
            end
         end

         def hsv_string(s = ", ")
            unless @h.nil?
               "#{@h}#{s}#{@s}#{s}#{@v}"
            else
               nil
            end
         end

         def rgb_to_hsv(r, g, b)
            Colors.rgb_to_hsv(r, g, b)
         end

         def hsv_to_rgb(h, s, v)
            Colors.hsv_to_rgb(h, s, v)
         end

         class <<self
            def rgb(r, g, b, a = nil)
               color = Colors.new
               color.rgb(r, g, b, a)
               color
            end

            def hsv(h, s, v)
               color = Colors.new
               color.hsv(h, s, v)
               color
            end

            def name(c)
               color = Colors.new
               color.name(c)
               color
            end

            def rgb_to_hsv(r, g, b)
               h, s, v = 0.0, 0.0, 0.0

               _r = r.convert_base(16, 10).to_f / 255.0
               _g = g.convert_base(16, 10).to_f / 255.0
               _b = b.convert_base(16, 10).to_f / 255.0
               rgb = [ _r, _g, _b ]

               min = rgb.min
               max = rgb.max
               v = max

               delta = max - min
               if max != 0.0
                  s = delta / max
               else
                  return [-1, 0, v]
               end

               if _r == max
                  h = ( _g - _b ) / delta
               elsif( _g == max )
                  h = 2 + ( _b - _r ) / delta
               else
                  h = 4 + ( _r - _g ) / delta
               end

               h = h * 60
               h = h + 360 if h < 0
               h = h / 360.0

               [h, s, v]
            end

            def hsv_to_rgb(h, s, v)
               _h, _s, _v = h.to_f * 360.0, s.to_f, v.to_f

               if _s == 0.0
                 r = (_v * 255 ).to_i.to_s.convert_base(10,16)
                 return [r, r, r]
               end

               _h = _h / 60.0
               i = _h.floor
               f = _h - i
               p = _v * ( 1.0 - _s )
               q = _v * ( 1.0 - _s * f )
               t = _v * ( 1.0 - _s * ( 1 - f ) )
               case i
               when 0
                  r = _v
                  g = t
                  b = p
               when 1
                  r = q
                  g = _v
                  b = p
               when 2
                  r = p
                  g = _v
                  b = t
               when 3
                  r = p
                  g = q
                  b = _v
               when 4
                  r = t
                  g = p
                  b = _v
               else
                  r = _v
                  g = p
                  b = q
               end

               [
                  (r * 255).to_i.to_s.convert_base(10, 16),
                  (g * 255).to_i.to_s.convert_base(10, 16),
                  (b * 255).to_i.to_s.convert_base(10, 16)
               ]
            end
         end

         COLORS = {
            "aliceblue" => "f0f8ff",
            "aliceblue" => "f0f8ff",
            "antiquewhite1" => "ffefdb",
            "antiquewhite2" => "eedfcc",
            "antiquewhite3" => "cdc0b0",
            "antiquewhite4" => "8b8378",
            "antiquewhite" => "faebd7",
            "antiquewhite" => "faebd7",
            "aqua" => "00ffff",
            "aquamarine1" => "7fffd4",
            "aquamarine2" => "76eec6",
            "aquamarine3" => "66cdaa",
            "aquamarine4" => "458b74",
            "aquamarine" => "7fffd4",
            "aquamarine" => "7fffd4",
            "azure1" => "f0ffff",
            "azure2" => "e0eeee",
            "azure3" => "c1cdcd",
            "azure4" => "838b8b",
            "azure" => "f0ffff",
            "azure" => "f0ffff",
            "beige" => "f5f5dc",
            "beige" => "f5f5dc",
            "bisque1" => "ffe4c4",
            "bisque2" => "eed5b7",
            "bisque3" => "cdb79e",
            "bisque4" => "8b7d6b",
            "bisque" => "ffe4c4",
            "bisque" => "ffe4c4",
            "black" => "000000",
            "black" => "000000",
            "blanchedalmond" => "ffebcd",
            "blanchedalmond" => "ffebcd",
            "blue" => "0000ff",
            "blue" => "0000ff",
            "blue1" => "0000ff",
            "blue2" => "0000ee",
            "blue3" => "0000cd",
            "blue4" => "00008b",
            "blueviolet" => "8a2be2",
            "blueviolet" => "8a2be2",
            "brown1" => "ff4040",
            "brown2" => "ee3b3b",
            "brown3" => "cd3333",
            "brown4" => "8b2323",
            "brown" => "a52a2a",
            "brown" => "a52a2a",
            "burlywood1" => "ffd39b",
            "burlywood2" => "eec591",
            "burlywood3" => "cdaa7d",
            "burlywood4" => "8b7355",
            "burlywood" => "deb887",
            "burlywood" => "deb887",
            "cadetblue1" => "98f5ff",
            "cadetblue2" => "8ee5ee",
            "cadetblue3" => "7ac5cd",
            "cadetblue4" => "53868b",
            "cadetblue" => "5f9ea0",
            "cadetblue" => "5f9ea0",
            "chartreuse1" => "7fff00",
            "chartreuse2" => "76ee00",
            "chartreuse3" => "66cd00",
            "chartreuse4" => "458b00",
            "chartreuse" => "7fff00",
            "chartreuse" => "7fff00",
            "chocolate1" => "ff7f24",
            "chocolate2" => "ee7621",
            "chocolate3" => "cd661d",
            "chocolate4" => "8b4513",
            "chocolate" => "d2691e",
            "chocolate" => "d2691e",
            "coral1" => "ff7256",
            "coral2" => "ee6a50",
            "coral3" => "cd5b45",
            "coral4" => "8b3e2f",
            "coral" => "ff7f50",
            "coral" => "ff7f50",
            "cornflowerblue" => "6495ed",
            "cornflowerblue" => "6495ed",
            "cornsilk1" => "fff8dc",
            "cornsilk2" => "eee8cd",
            "cornsilk3" => "cdc8b1",
            "cornsilk4" => "8b8878",
            "cornsilk" => "fff8dc",
            "cornsilk" => "fff8dc",
            "crimson" => "dc143c",
            "crimson" => "dc143c",
            "cyan" => "00ffff",
            "cyan" => "00ffff",
            "cyan1" => "00ffff",
            "cyan2" => "00eeee",
            "cyan3" => "00cdcd",
            "cyan4" => "008b8b",
            "darkblue" => "00008b",
            "darkcyan" => "008b8b",
            "darkgoldenrod1" => "ffb90f",
            "darkgoldenrod2" => "eead0e",
            "darkgoldenrod3" => "cd950c",
            "darkgoldenrod4" => "8b6508",
            "darkgoldenrod" => "b8860b",
            "darkgoldenrod" => "b8860b",
            "darkgray" => "a9a9a9",
            "darkgreen" => "006400",
            "darkgreen" => "006400",
            "darkgrey" => "a9a9a9",
            "darkkhaki" => "bdb76b",
            "darkkhaki" => "bdb76b",
            "darkmagenta" => "8b008b",
            "darkolivegreen1" => "caff70",
            "darkolivegreen2" => "bcee68",
            "darkolivegreen3" => "a2cd5a",
            "darkolivegreen4" => "6e8b3d",
            "darkolivegreen" => "556b2f",
            "darkolivegreen" => "556b2f",
            "darkorange1" => "ff7f00",
            "darkorange2" => "ee7600",
            "darkorange3" => "cd6600",
            "darkorange4" => "8b4500",
            "darkorange" => "ff8c00",
            "darkorange" => "ff8c00",
            "darkorchid1" => "bf3eff",
            "darkorchid2" => "b23aee",
            "darkorchid3" => "9a32cd",
            "darkorchid4" => "68228b",
            "darkorchid" => "9932cc",
            "darkorchid" => "9932cc",
            "darkred" => "8b0000",
            "darksalmon" => "e9967a",
            "darksalmon" => "e9967a",
            "darkseagreen1" => "c1ffc1",
            "darkseagreen2" => "b4eeb4",
            "darkseagreen3" => "9bcd9b",
            "darkseagreen4" => "698b69",
            "darkseagreen" => "8fbc8f",
            "darkseagreen" => "8fbc8f",
            "darkslateblue" => "483d8b",
            "darkslateblue" => "483d8b",
            "darkslategray1" => "97ffff",
            "darkslategray2" => "8deeee",
            "darkslategray" => "2f4f4f",
            "darkslategray" => "2f4f4f",
            "darkslategray3" => "79cdcd",
            "darkslategray4" => "528b8b",
            "darkslategrey" => "2f4f4f",
            "darkslategrey" => "2f4f4f",
            "darkturquoise" => "00ced1",
            "darkturquoise" => "00ced1",
            "darkviolet" => "9400d3",
            "darkviolet" => "9400d3",
            "deeppink1" => "ff1493",
            "deeppink2" => "ee1289",
            "deeppink3" => "cd1076",
            "deeppink4" => "8b0a50",
            "deeppink" => "ff1493",
            "deeppink" => "ff1493",
            "deepskyblue" => "00bfff",
            "deepskyblue" => "00bfff",
            "deepskyblue1" => "00bfff",
            "deepskyblue2" => "00b2ee",
            "deepskyblue3" => "009acd",
            "deepskyblue4" => "00688b",
            "dimgray" => "696969",
            "dimgray" => "696969",
            "dimgrey" => "696969",
            "dimgrey" => "696969",
            "dodgerblue1" => "1e90ff",
            "dodgerblue" => "1e90ff",
            "dodgerblue" => "1e90ff",
            "dodgerblue2" => "1c86ee",
            "dodgerblue3" => "1874cd",
            "dodgerblue4" => "104e8b",
            "firebrick1" => "ff3030",
            "firebrick2" => "ee2c2c",
            "firebrick3" => "cd2626",
            "firebrick4" => "8b1a1a",
            "firebrick" => "b22222",
            "firebrick" => "b22222",
            "floralwhite" => "fffaf0",
            "floralwhite" => "fffaf0",
            "forestgreen" => "228b22",
            "forestgreen" => "228b22",
            "fuchsia" => "ff00ff",
            "gainsboro" => "dcdcdc",
            "gainsboro" => "dcdcdc",
            "ghostwhite" => "f8f8ff",
            "ghostwhite" => "f8f8ff",
            "gold1" => "ffd700",
            "gold2" => "eec900",
            "gold3" => "cdad00",
            "gold4" => "8b7500",
            "goldenrod1" => "ffc125",
            "goldenrod2" => "eeb422",
            "goldenrod3" => "cd9b1d",
            "goldenrod4" => "8b6914",
            "goldenrod" => "daa520",
            "goldenrod" => "daa520",
            "gold" => "ffd700",
            "gold" => "ffd700",
            "gray0" => "000000",
            "gray100" => "ffffff",
            "gray10" => "1a1a1a",
            "gray1" => "030303",
            "gray11" => "1c1c1c",
            "gray12" => "1f1f1f",
            "gray13" => "212121",
            "gray14" => "242424",
            "gray15" => "262626",
            "gray16" => "292929",
            "gray17" => "2b2b2b",
            "gray18" => "2e2e2e",
            "gray19" => "303030",
            "gray20" => "333333",
            "gray2" => "050505",
            "gray21" => "363636",
            "gray22" => "383838",
            "gray23" => "3b3b3b",
            "gray24" => "3d3d3d",
            "gray25" => "404040",
            "gray26" => "424242",
            "gray27" => "454545",
            "gray28" => "474747",
            "gray29" => "4a4a4a",
            "gray30" => "4d4d4d",
            "gray3" => "080808",
            "gray31" => "4f4f4f",
            "gray32" => "525252",
            "gray33" => "545454",
            "gray34" => "575757",
            "gray35" => "595959",
            "gray36" => "5c5c5c",
            "gray37" => "5e5e5e",
            "gray38" => "616161",
            "gray39" => "636363",
            "gray40" => "666666",
            "gray4" => "0a0a0a",
            "gray41" => "696969",
            "gray42" => "6b6b6b",
            "gray43" => "6e6e6e",
            "gray44" => "707070",
            "gray45" => "737373",
            "gray46" => "757575",
            "gray47" => "787878",
            "gray48" => "7a7a7a",
            "gray49" => "7d7d7d",
            "gray50" => "7f7f7f",
            "gray5" => "0d0d0d",
            "gray51" => "828282",
            "gray52" => "858585",
            "gray53" => "878787",
            "gray54" => "8a8a8a",
            "gray55" => "8c8c8c",
            "gray56" => "8f8f8f",
            "gray57" => "919191",
            "gray58" => "949494",
            "gray59" => "969696",
            "gray60" => "999999",
            "gray6" => "0f0f0f",
            "gray61" => "9c9c9c",
            "gray62" => "9e9e9e",
            "gray63" => "a1a1a1",
            "gray64" => "a3a3a3",
            "gray65" => "a6a6a6",
            "gray66" => "a8a8a8",
            "gray67" => "ababab",
            "gray68" => "adadad",
            "gray69" => "b0b0b0",
            "gray70" => "b3b3b3",
            "gray7" => "121212",
            "gray71" => "b5b5b5",
            "gray72" => "b8b8b8",
            "gray73" => "bababa",
            "gray74" => "bdbdbd",
            "gray75" => "bfbfbf",
            "gray76" => "c2c2c2",
            "gray77" => "c4c4c4",
            "gray78" => "c7c7c7",
            "gray79" => "c9c9c9",
            "gray" => "808080",
            "gray80" => "cccccc",
            "gray8" => "141414",
            "gray81" => "cfcfcf",
            "gray82" => "d1d1d1",
            "gray83" => "d4d4d4",
            "gray84" => "d6d6d6",
            "gray85" => "d9d9d9",
            "gray86" => "dbdbdb",
            "gray87" => "dedede",
            "gray88" => "e0e0e0",
            "gray89" => "e3e3e3",
            "gray90" => "e5e5e5",
            "gray9" => "171717",
            "gray91" => "e8e8e8",
            "gray92" => "ebebeb",
            "gray93" => "ededed",
            "gray94" => "f0f0f0",
            "gray95" => "f2f2f2",
            "gray96" => "f5f5f5",
            "gray97" => "f7f7f7",
            "gray98" => "fafafa",
            "gray99" => "fcfcfc",
            "gray" => "c0c0c0",
            "green" => "008000",
            "green" => "00ff00",
            "green1" => "00ff00",
            "green2" => "00ee00",
            "green3" => "00cd00",
            "green4" => "008b00",
            "greenyellow" => "adff2f",
            "greenyellow" => "adff2f",
            "grey0" => "000000",
            "grey100" => "ffffff",
            "grey10" => "1a1a1a",
            "grey1" => "030303",
            "grey11" => "1c1c1c",
            "grey12" => "1f1f1f",
            "grey13" => "212121",
            "grey14" => "242424",
            "grey15" => "262626",
            "grey16" => "292929",
            "grey17" => "2b2b2b",
            "grey18" => "2e2e2e",
            "grey19" => "303030",
            "grey20" => "333333",
            "grey2" => "050505",
            "grey21" => "363636",
            "grey22" => "383838",
            "grey23" => "3b3b3b",
            "grey24" => "3d3d3d",
            "grey25" => "404040",
            "grey26" => "424242",
            "grey27" => "454545",
            "grey28" => "474747",
            "grey29" => "4a4a4a",
            "grey30" => "4d4d4d",
            "grey3" => "080808",
            "grey31" => "4f4f4f",
            "grey32" => "525252",
            "grey33" => "545454",
            "grey34" => "575757",
            "grey35" => "595959",
            "grey36" => "5c5c5c",
            "grey37" => "5e5e5e",
            "grey38" => "616161",
            "grey39" => "636363",
            "grey40" => "666666",
            "grey4" => "0a0a0a",
            "grey41" => "696969",
            "grey42" => "6b6b6b",
            "grey43" => "6e6e6e",
            "grey44" => "707070",
            "grey45" => "737373",
            "grey46" => "757575",
            "grey47" => "787878",
            "grey48" => "7a7a7a",
            "grey49" => "7d7d7d",
            "grey50" => "7f7f7f",
            "grey5" => "0d0d0d",
            "grey51" => "828282",
            "grey52" => "858585",
            "grey53" => "878787",
            "grey54" => "8a8a8a",
            "grey55" => "8c8c8c",
            "grey56" => "8f8f8f",
            "grey57" => "919191",
            "grey58" => "949494",
            "grey59" => "969696",
            "grey60" => "999999",
            "grey6" => "0f0f0f",
            "grey61" => "9c9c9c",
            "grey62" => "9e9e9e",
            "grey63" => "a1a1a1",
            "grey64" => "a3a3a3",
            "grey65" => "a6a6a6",
            "grey66" => "a8a8a8",
            "grey67" => "ababab",
            "grey68" => "adadad",
            "grey69" => "b0b0b0",
            "grey70" => "b3b3b3",
            "grey7" => "121212",
            "grey71" => "b5b5b5",
            "grey72" => "b8b8b8",
            "grey73" => "bababa",
            "grey74" => "bdbdbd",
            "grey75" => "bfbfbf",
            "grey76" => "c2c2c2",
            "grey77" => "c4c4c4",
            "grey78" => "c7c7c7",
            "grey79" => "c9c9c9",
            "grey" => "808080",
            "grey80" => "cccccc",
            "grey8" => "141414",
            "grey81" => "cfcfcf",
            "grey82" => "d1d1d1",
            "grey83" => "d4d4d4",
            "grey84" => "d6d6d6",
            "grey85" => "d9d9d9",
            "grey86" => "dbdbdb",
            "grey87" => "dedede",
            "grey88" => "e0e0e0",
            "grey89" => "e3e3e3",
            "grey90" => "e5e5e5",
            "grey9" => "171717",
            "grey91" => "e8e8e8",
            "grey92" => "ebebeb",
            "grey93" => "ededed",
            "grey94" => "f0f0f0",
            "grey95" => "f2f2f2",
            "grey96" => "f5f5f5",
            "grey97" => "f7f7f7",
            "grey98" => "fafafa",
            "grey99" => "fcfcfc",
            "grey" => "c0c0c0",
            "honeydew1" => "f0fff0",
            "honeydew2" => "e0eee0",
            "honeydew3" => "c1cdc1",
            "honeydew4" => "838b83",
            "honeydew" => "f0fff0",
            "honeydew" => "f0fff0",
            "hotpink1" => "ff6eb4",
            "hotpink2" => "ee6aa7",
            "hotpink3" => "cd6090",
            "hotpink4" => "8b3a62",
            "hotpink" => "ff69b4",
            "hotpink" => "ff69b4",
            "indianred1" => "ff6a6a",
            "indianred2" => "ee6363",
            "indianred3" => "cd5555",
            "indianred4" => "8b3a3a",
            "indianred" => "cd5c5c",
            "indianred" => "cd5c5c",
            "indigo" => "4b0082",
            "indigo" => "4b0082",
            "invis" => "fffffe",
            "ivory1" => "fffff0",
            "ivory2" => "eeeee0",
            "ivory3" => "cdcdc1",
            "ivory4" => "8b8b83",
            "ivory" => "fffff0",
            "ivory" => "fffff0",
            "khaki1" => "fff68f",
            "khaki2" => "eee685",
            "khaki3" => "cdc673",
            "khaki4" => "8b864e",
            "khaki" => "f0e68c",
            "khaki" => "f0e68c",
            "lavenderblush1" => "fff0f5",
            "lavenderblush2" => "eee0e5",
            "lavenderblush3" => "cdc1c5",
            "lavenderblush4" => "8b8386",
            "lavenderblush" => "fff0f5",
            "lavenderblush" => "fff0f5",
            "lavender" => "e6e6fa",
            "lavender" => "e6e6fa",
            "lawngreen" => "7cfc00",
            "lawngreen" => "7cfc00",
            "lemonchiffon1" => "fffacd",
            "lemonchiffon2" => "eee9bf",
            "lemonchiffon3" => "cdc9a5",
            "lemonchiffon4" => "8b8970",
            "lemonchiffon" => "fffacd",
            "lemonchiffon" => "fffacd",
            "lightblue1" => "bfefff",
            "lightblue2" => "b2dfee",
            "lightblue3" => "9ac0cd",
            "lightblue4" => "68838b",
            "lightblue" => "add8e6",
            "lightblue" => "add8e6",
            "lightcoral" => "f08080",
            "lightcoral" => "f08080",
            "lightcyan1" => "e0ffff",
            "lightcyan2" => "d1eeee",
            "lightcyan3" => "b4cdcd",
            "lightcyan4" => "7a8b8b",
            "lightcyan" => "e0ffff",
            "lightcyan" => "e0ffff",
            "lightgoldenrod1" => "ffec8b",
            "lightgoldenrod2" => "eedc82",
            "lightgoldenrod3" => "cdbe70",
            "lightgoldenrod4" => "8b814c",
            "lightgoldenrod" => "eedd82",
            "lightgoldenrodyellow" => "fafad2",
            "lightgoldenrodyellow" => "fafad2",
            "lightgray" => "d3d3d3",
            "lightgray" => "d3d3d3",
            "lightgreen" => "90ee90",
            "lightgrey" => "d3d3d3",
            "lightgrey" => "d3d3d3",
            "lightpink1" => "ffaeb9",
            "lightpink2" => "eea2ad",
            "lightpink3" => "cd8c95",
            "lightpink4" => "8b5f65",
            "lightpink" => "ffb6c1",
            "lightpink" => "ffb6c1",
            "lightsalmon1" => "ffa07a",
            "lightsalmon2" => "ee9572",
            "lightsalmon3" => "cd8162",
            "lightsalmon4" => "8b5742",
            "lightsalmon" => "ffa07a",
            "lightsalmon" => "ffa07a",
            "lightseagreen" => "20b2aa",
            "lightseagreen" => "20b2aa",
            "lightskyblue1" => "b0e2ff",
            "lightskyblue2" => "a4d3ee",
            "lightskyblue3" => "8db6cd",
            "lightskyblue4" => "607b8b",
            "lightskyblue" => "87cefa",
            "lightskyblue" => "87cefa",
            "lightslateblue" => "8470ff",
            "lightslategray" => "778899",
            "lightslategray" => "778899",
            "lightslategrey" => "778899",
            "lightslategrey" => "778899",
            "lightsteelblue1" => "cae1ff",
            "lightsteelblue2" => "bcd2ee",
            "lightsteelblue3" => "a2b5cd",
            "lightsteelblue4" => "6e7b8b",
            "lightsteelblue" => "b0c4de",
            "lightsteelblue" => "b0c4de",
            "lightyellow1" => "ffffe0",
            "lightyellow2" => "eeeed1",
            "lightyellow3" => "cdcdb4",
            "lightyellow4" => "8b8b7a",
            "lightyellow" => "ffffe0",
            "lightyellow" => "ffffe0",
            "lime" => "00ff00",
            "limegreen" => "32cd32",
            "limegreen" => "32cd32",
            "linen" => "faf0e6",
            "linen" => "faf0e6",
            "magenta1" => "ff00ff",
            "magenta2" => "ee00ee",
            "magenta3" => "cd00cd",
            "magenta4" => "8b008b",
            "magenta" => "ff00ff",
            "magenta" => "ff00ff",
            "maroon1" => "ff34b3",
            "maroon2" => "ee30a7",
            "maroon3" => "cd2990",
            "maroon4" => "8b1c62",
            "maroon" => "800000",
            "maroon" => "b03060",
            "mediumaquamarine" => "66cdaa",
            "mediumaquamarine" => "66cdaa",
            "mediumblue" => "0000cd",
            "mediumblue" => "0000cd",
            "mediumorchid1" => "e066ff",
            "mediumorchid2" => "d15fee",
            "mediumorchid3" => "b452cd",
            "mediumorchid4" => "7a378b",
            "mediumorchid" => "ba55d3",
            "mediumorchid" => "ba55d3",
            "mediumpurple1" => "ab82ff",
            "mediumpurple2" => "9f79ee",
            "mediumpurple3" => "8968cd",
            "mediumpurple4" => "5d478b",
            "mediumpurple" => "9370db",
            "mediumpurple" => "9370db",
            "mediumseagreen" => "3cb371",
            "mediumseagreen" => "3cb371",
            "mediumslateblue" => "7b68ee",
            "mediumslateblue" => "7b68ee",
            "mediumspringgreen" => "00fa9a",
            "mediumspringgreen" => "00fa9a",
            "mediumturquoise" => "48d1cc",
            "mediumturquoise" => "48d1cc",
            "mediumvioletred" => "c71585",
            "mediumvioletred" => "c71585",
            "midnightblue" => "191970",
            "midnightblue" => "191970",
            "mintcream" => "f5fffa",
            "mintcream" => "f5fffa",
            "mistyrose1" => "ffe4e1",
            "mistyrose2" => "eed5d2",
            "mistyrose3" => "cdb7b5",
            "mistyrose4" => "8b7d7b",
            "mistyrose" => "ffe4e1",
            "mistyrose" => "ffe4e1",
            "moccasin" => "ffe4b5",
            "moccasin" => "ffe4b5",
            "navajowhite1" => "ffdead",
            "navajowhite2" => "eecfa1",
            "navajowhite3" => "cdb38b",
            "navajowhite4" => "8b795e",
            "navajowhite" => "ffdead",
            "navajowhite" => "ffdead",
            "navy" => "000080",
            "navy" => "000080",
            "navyblue" => "000080",
            "none" => "fffffe",
            "oldlace" => "fdf5e6",
            "oldlace" => "fdf5e6",
            "olive" => "808000",
            "olivedrab1" => "c0ff3e",
            "olivedrab2" => "b3ee3a",
            "olivedrab3" => "9acd32",
            "olivedrab4" => "698b22",
            "olivedrab" => "6b8e23",
            "olivedrab" => "6b8e23",
            "orange1" => "ffa500",
            "orange2" => "ee9a00",
            "orange3" => "cd8500",
            "orange4" => "8b5a00",
            "orange" => "ffa500",
            "orange" => "ffa500",
            "orangered1" => "ff4500",
            "orangered2" => "ee4000",
            "orangered3" => "cd3700",
            "orangered4" => "8b2500",
            "orangered" => "ff4500",
            "orangered" => "ff4500",
            "orchid1" => "ff83fa",
            "orchid2" => "ee7ae9",
            "orchid3" => "cd69c9",
            "orchid4" => "8b4789",
            "orchid" => "da70d6",
            "orchid" => "da70d6",
            "palegoldenrod" => "eee8aa",
            "palegoldenrod" => "eee8aa",
            "palegreen1" => "9aff9a",
            "palegreen2" => "90ee90",
            "palegreen3" => "7ccd7c",
            "palegreen4" => "548b54",
            "palegreen" => "98fb98",
            "palegreen" => "98fb98",
            "paleturquoise1" => "bbffff",
            "paleturquoise2" => "aeeeee",
            "paleturquoise3" => "96cdcd",
            "paleturquoise4" => "668b8b",
            "paleturquoise" => "afeeee",
            "paleturquoise" => "afeeee",
            "palevioletred1" => "ff82ab",
            "palevioletred2" => "ee799f",
            "palevioletred3" => "cd6889",
            "palevioletred4" => "8b475d",
            "palevioletred" => "db7093",
            "palevioletred" => "db7093",
            "papayawhip" => "ffefd5",
            "papayawhip" => "ffefd5",
            "peachpuff1" => "ffdab9",
            "peachpuff2" => "eecbad",
            "peachpuff3" => "cdaf95",
            "peachpuff4" => "8b7765",
            "peachpuff" => "ffdab9",
            "peachpuff" => "ffdab9",
            "peru" => "cd853f",
            "peru" => "cd853f",
            "pink1" => "ffb5c5",
            "pink2" => "eea9b8",
            "pink3" => "cd919e",
            "pink4" => "8b636c",
            "pink" => "ffc0cb",
            "pink" => "ffc0cb",
            "plum1" => "ffbbff",
            "plum2" => "eeaeee",
            "plum3" => "cd96cd",
            "plum4" => "8b668b",
            "plum" => "dda0dd",
            "plum" => "dda0dd",
            "powderblue" => "b0e0e6",
            "powderblue" => "b0e0e6",
            "purple1" => "9b30ff",
            "purple2" => "912cee",
            "purple3" => "7d26cd",
            "purple4" => "551a8b",
            "purple" => "800080",
            "purple" => "a020f0",
            "red1" => "ff0000",
            "red2" => "ee0000",
            "red3" => "cd0000",
            "red4" => "8b0000",
            "red" => "ff0000",
            "red" => "ff0000",
            "rosybrown1" => "ffc1c1",
            "rosybrown2" => "eeb4b4",
            "rosybrown3" => "cd9b9b",
            "rosybrown4" => "8b6969",
            "rosybrown" => "bc8f8f",
            "rosybrown" => "bc8f8f",
            "royalblue1" => "4876ff",
            "royalblue2" => "436eee",
            "royalblue3" => "3a5fcd",
            "royalblue" => "4169e1",
            "royalblue" => "4169e1",
            "royalblue4" => "27408b",
            "saddlebrown" => "8b4513",
            "saddlebrown" => "8b4513",
            "salmon1" => "ff8c69",
            "salmon2" => "ee8262",
            "salmon3" => "cd7054",
            "salmon4" => "8b4c39",
            "salmon" => "fa8072",
            "salmon" => "fa8072",
            "sandybrown" => "f4a460",
            "sandybrown" => "f4a460",
            "seagreen1" => "54ff9f",
            "seagreen2" => "4eee94",
            "seagreen" => "2e8b57",
            "seagreen" => "2e8b57",
            "seagreen3" => "43cd80",
            "seagreen4" => "2e8b57",
            "seashell1" => "fff5ee",
            "seashell2" => "eee5de",
            "seashell3" => "cdc5bf",
            "seashell4" => "8b8682",
            "seashell" => "fff5ee",
            "seashell" => "fff5ee",
            "sienna1" => "ff8247",
            "sienna2" => "ee7942",
            "sienna3" => "cd6839",
            "sienna4" => "8b4726",
            "sienna" => "a0522d",
            "sienna" => "a0522d",
            "silver" => "c0c0c0",
            "skyblue1" => "87ceff",
            "skyblue2" => "7ec0ee",
            "skyblue3" => "6ca6cd",
            "skyblue4" => "4a708b",
            "skyblue" => "87ceeb",
            "skyblue" => "87ceeb",
            "slateblue1" => "836fff",
            "slateblue2" => "7a67ee",
            "slateblue3" => "6959cd",
            "slateblue4" => "473c8b",
            "slateblue" => "6a5acd",
            "slateblue" => "6a5acd",
            "slategray1" => "c6e2ff",
            "slategray2" => "b9d3ee",
            "slategray3" => "9fb6cd",
            "slategray4" => "6c7b8b",
            "slategray" => "708090",
            "slategray" => "708090",
            "slategrey" => "708090",
            "slategrey" => "708090",
            "snow1" => "fffafa",
            "snow2" => "eee9e9",
            "snow3" => "cdc9c9",
            "snow4" => "8b8989",
            "snow" => "fffafa",
            "snow" => "fffafa",
            "springgreen" => "00ff7f",
            "springgreen" => "00ff7f",
            "springgreen1" => "00ff7f",
            "springgreen2" => "00ee76",
            "springgreen3" => "00cd66",
            "springgreen4" => "008b45",
            "steelblue1" => "63b8ff",
            "steelblue2" => "5cacee",
            "steelblue3" => "4f94cd",
            "steelblue4" => "36648b",
            "steelblue" => "4682b4",
            "steelblue" => "4682b4",
            "tan1" => "ffa54f",
            "tan2" => "ee9a49",
            "tan3" => "cd853f",
            "tan4" => "8b5a2b",
            "tan" => "d2b48c",
            "tan" => "d2b48c",
            "teal" => "008080",
            "thistle1" => "ffe1ff",
            "thistle2" => "eed2ee",
            "thistle3" => "cdb5cd",
            "thistle4" => "8b7b8b",
            "thistle" => "d8bfd8",
            "thistle" => "d8bfd8",
            "tomato1" => "ff6347",
            "tomato2" => "ee5c42",
            "tomato3" => "cd4f39",
            "tomato4" => "8b3626",
            "tomato" => "ff6347",
            "tomato" => "ff6347",
            "transparent" => "fffffe",
            "turquoise1" => "00f5ff",
            "turquoise2" => "00e5ee",
            "turquoise3" => "00c5cd",
            "turquoise4" => "00868b",
            "turquoise" => "40e0d0",
            "turquoise" => "40e0d0",
            "violet" => "ee82ee",
            "violet" => "ee82ee",
            "violetred1" => "ff3e96",
            "violetred2" => "ee3a8c",
            "violetred3" => "cd3278",
            "violetred4" => "8b2252",
            "violetred" => "d02090",
            "wheat1" => "ffe7ba",
            "wheat2" => "eed8ae",
            "wheat3" => "cdba96",
            "wheat4" => "8b7e66",
            "wheat" => "f5deb3",
            "wheat" => "f5deb3",
            "white" => "ffffff",
            "white" => "ffffff",
            "whitesmoke" => "f5f5f5",
            "whitesmoke" => "f5f5f5",
            "yellow1" => "ffff00",
            "yellow2" => "eeee00",
            "yellow3" => "cdcd00",
            "yellow4" => "8b8b00",
            "yellow" => "ffff00",
            "yellow" => "ffff00",
            "yellowgreen" => "9acd32"
            "yellowgreen" => "9acd32",
         }
      end
   end
end

