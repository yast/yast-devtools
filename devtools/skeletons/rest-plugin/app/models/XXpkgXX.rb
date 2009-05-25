
# import YastService class
require "yast_service"

# models XXPkgXX objects
class XXPkgXX

    # FIXME: adapt to your model, add members to store all needed properties
    attr_accessor   :name,
		    :parameters

    def initialize
	# unique identification (name, ID number, ...)
	@name = nil

	# attributes
	# FIXME: adapt to your model, add as many members as needed...
	# initialize them to a default or empty values
	@parameters = nil
    end

    def XXPkgXX.find_all()
	# read IDs of all existing items

	# FIXME: Use the correct Yast function call, e.g.
	# items = YastService.Call("YaPI::XXPkgXX::List")
	
	items = [ "first", "second", "last" ] # FIXME: remove this dummy line

	# FIXME optionaly sort the result
	items.sort!

	result = [ ]

	# convert the list of items to list of objects
	items.each { |p|
	    item = XXPkgXX.new

	    # set only ID, the other parameters should have default or empty values
	    item.name = p

	    result << item
	}

	return result
    end

    def find
        # cannot find invalid object
	return false if @name.blank? 

	# get properties of the object

	# FIXME: Use the correct Yast function call, e.g.
	# properties = YastService.Call("YaPI::XXPkgXX::Get", @name)

	properties = { :p1 => "foo", :p2 => "bar" } # FIXME: remove this dummy line

	# check the value
	if properties.nil? || properties == {}
	    @parameters = nil
	    return false
	else
	    # FIXME update all class members
	    @parameters = properties
	    return true
	end
    end

    def update_attributes(attribs)
	if attribs.has_key?(:name)
	    new_name = attribs[:name]

	    # FIXME: valide the option
	    if new_name.class != :String
		return false
	    end

	    @name = new_name
	end

	if attribs.has_key?(:parameters)
	    new_params = attribs[:parameters]

	    # FIXME: valide the option
	    if new_params.class != :Hash
		return false
	    end

	    @parameters = new_params
	end

	# FIXME: update all properties here...

	return true
    end

    def add
	# FIXME: Use the correct Yast function call, e.g.
	# return YastService.Call("YaPI::XXPkgXX::Add", @name, @parameters) if !@name.blank?

	return false
    end

    def edit
	# FIXME: Use the correct Yast function call, e.g.
	# return YastService.Call("YaPI::XXPkgXX::Edit", @name, @parameters) if !@name.blank?

	return false
    end

    def delete
	# FIXME: Use the correct Yast function call, e.g.
	# return YastService.Call("YaPI::XXPkgXX::Delete", @name) if !@name.blank?

	return false
    end

    # FIXME: export all members in XML
    def to_xml( options = {} )
	return nil if @name.nil?

	xml = options[:builder] ||= Builder::XmlMarkup.new(options)
	xml.instruct! unless options[:skip_instruct]

	xml.XXpkgXX do
	    xml.tag!(:name, @name)

	    if !@parameters.blank?
		# FIXME: Note: the first parameter of tag! is tag name, the second is value,
		# the result is <parameters>[value of @parameter]</parameters>
		# see http://api.rubyonrails.org/classes/Builder/XmlMarkup.html
		xml.tag!(:parameters, @parameters)
	    end
	end
    end

    # export the object in JSON format
    # reuse the XML builder functionality
    def to_json( options = {} )
	hash = Hash.from_xml(to_xml())
	return hash.to_json
    end

end

# vim: ft=ruby
