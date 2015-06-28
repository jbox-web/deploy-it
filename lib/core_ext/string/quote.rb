# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

class String

  # Return a new string embraced by given +type+ and +count+
  # of quotes. The arguments can be given in any order.
  #
  # If no type is given, double quotes are assumed.
  #
  #   "quote me".quote     #=> '"quote me"'
  #
  # If no type but a count is given then :mixed is assumed.
  #
  #   "quote me".quote(1)  #=> %q{'quote me'}
  #   "quote me".quote(2)  #=> %q{"quote me"}
  #   "quote me".quote(3)  #=> %q{'"quote me"'}
  #
  # Symbols can be used to describe the type.
  #
  #   "quote me".quote(:single)    #=> %q{'quote me'}
  #   "quote me".quote(:double)    #=> %q{"quote me"}
  #   "quote me".quote(:back)      #=> %q{`quote me`}
  #   "quote me".quote(:bracket)   #=> %q{`quote me'}
  #
  # Or the character itself.
  #
  #   "quote me".quote("'")     #=> %q{'quote me'}
  #   "quote me".quote('"')     #=> %q{"quote me"}
  #   "quote me".quote("`")     #=> %q{`quote me`}
  #   "quote me".quote("`'")    #=> %q{`quote me'}
  #
  # CREDIT: Trans

  def quote(type=:double, count=nil)
    if Integer === type
      tmp   = count
      count = type
      type  = tmp || :mixed
    else
      count ||= 1
    end

    type = type.to_s unless Integer===type

    case type
    when "'", 'single', 's', 1
      f = "'" * count
      b = f
    when '"', 'double', 'd', 2
      f = '"' * count
      b = f
    when '`', 'back', 'b', -1
      f = '`' * count
      b = f
    when "`'", 'bracket', 'sb'
      f = "`" * count
      b = "'" * count
    when "'\"", 'mixed', "m", Integer
      c = (count.to_f / 2).to_i
      f = '"' * c
      b = f
      if count % 2 != 0
        f = "'" + f
        b = b + "'"
      end
    else
      raise ArgumentError, "unrecognized quote type -- #{type}"
    end
    "#{f}#{self}#{b}"
  end

  # Remove quotes from string.
  #
  #   "'hi'".unquote    #=> "hi"
  #
  # CREDIT: Trans

  def unquote
    s = self.dup

    case self[0,1]
    when "'", '"', '`'
      s[0] = ''
    end

    case self[-1,1]
    when "'", '"', '`'
      s[-1] = ''
    end

    return s
  end

end
