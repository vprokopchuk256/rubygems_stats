class Format < OpenStruct
  def initialize name
    super name: name
  end

  def configure_attrs args, options, *attrs
    attrs.collect{|a| [name, a].join('_')}.each do |attr_name|
      args.on("--#{attr_name.to_s.dasherize} {String}", attr_name.to_s.humanize) do |v|
        options[attr_name] = v
      end
    end
  end

  def configure_value args, options
    args.on("--#{name.to_s.dasherize} {String}", name.to_s.humanize) do |v|
      options[name] = v
    end
  end

  def load_from opts
    opts.select{|k,_| k.to_s.match(name.to_s) }.each do |full_name, value|
      attr_name = full_name == name ? 'label' : full_name.to_s.gsub(/^#{name}\_/, "")

      self.send("#{attr_name}=", value)
    end

    self
  end

  def for name
    self.class.for(name).load_from(self.to_h)
  end

  class << self
    alias_method :for, :new
  end
end
