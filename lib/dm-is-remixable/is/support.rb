class Object

  def full_const_defined?(name)
    !!full_const_get(name) rescue false
  end

end

# TODO find out why this is needed
Extlib::Inflection.rule 'ess', 'esses'
