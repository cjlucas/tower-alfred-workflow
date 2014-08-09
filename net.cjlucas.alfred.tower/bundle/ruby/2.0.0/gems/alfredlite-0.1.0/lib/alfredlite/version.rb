module Alfred
  class Version
    MAJOR = 0
    MINOR = 1
    TINY  = 0
  end
 
  VERSION = [Version::MAJOR, Version::MINOR, Version::TINY].join('.')
 
end
