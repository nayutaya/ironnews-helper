
module AppEngine
  class Memcache
    def memcache_value(obj)
      case obj
      when Fixnum
        java.lang.Long.new(obj)
      when Float
        java.lang.Double.new(obj)
      when TrueClass, FalseClass
        java.lang.Boolean.new(obj)
      when JavaProxy, Java::JavaObject
        obj
      else
        if obj.class == String
          # Convert plain strings to Java strings
          #obj.to_java_string       # delete
          java.lang.String.new(obj) # add
        else
          bytes = Marshal.dump(obj).to_java_bytes
          java.util.ArrayList.new([MARSHAL_MARKER.to_java_string, bytes])
        end
      end
    end
  end
end
