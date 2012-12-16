class SimpleShowHelper
  def humanize(o)
    return case o.class.to_s
             when "Time", "ActiveSupport::TimeWithZone" then
               l(o, format: :long)
             when "TrueClass" then
               I18n.t(:true)
             when "FalseClass" then
               I18n.t(:no)
             when "Hash" then
               d = Array.new
               o.keys.sort.each do |k|
                 d << [k, humanize(o[k])]
               end
               render_table(d, @table_class)
             when NilClass
               '...'
             else
               o.to_s
           end

  end

  def render_table(data, table_class)
    s = "<table class=\"#{table_class}\">"
    data.each do |dat|
      s += "<tr>\n"
      dat.each do |d|
        s += "<td>#{d}</td>\n"
      end
      s += "</tr>\n"
    end
    s += "</table>"

    return s
  end

  def scan_object
    # column used to describe association
    association_desc_keys = ["name", "email", "desc", "type", "id"]
    special_attrs = ["id", "created_at", "updated_at"]
    object_tableize = @object.class.to_s.tableize.singularize

    # foreign keys, beware! magic!
    assoc_keys = @object.class.reflect_on_all_associations.collect { |a| a.foreign_key }.uniq & @object.attributes.keys
    # associations classes
    associations = Hash.new
    assoc_keys.each do |ak|
      associations[ak] = @object.class.reflect_on_all_associations.select { |a| a.foreign_key == ak }.first.klass
    end

    if @options[:attrs]
      attrs = @options[:attrs].collect { |k| k.to_s }
    else
      # remove special attributes
      attrs = @object.attributes.keys.sort
      special_attrs.each do |s|
        attrs.delete(s)
      end
    end

    # model's regular attributes
    details = Array.new
    attrs.each do |d|
      # key = I18n.t("#{object_tableize}.#{d}")
      key = @object.class.human_attribute_name(d)
      value = @object.attributes[d]


      if assoc_keys.include?(d)
        # nobody wants id
        value = ""

        r = associations[d].where(id: value.to_i).first
        if r
          can_read = can?(:read, r)


          association_desc_keys.each do |ak|
            if r.attributes[ak]
              value = r.attributes[ak]
              break
            end
          end

          # if can read, link to it
          if can_read
            value = "<a href=\"#{url_for(r)}\">#{value}</a>"
          end
        end

      end

      #details << [, m.attributes[d]]
      # http://apidock.com/rails/ActiveModel/Translation/human_attribute_name
      details << [key, value]
    end

    # timestamps
    if @options[:timestamps]
      #details << [m.class.human_attribute_name("created_at"), l(m.attributes["created_at"], format: :long)]
      #details << [m.class.human_attribute_name("updated_at"), l(m.attributes["updated_at"], format: :long)]
      details << [I18n.t("created_at"), @object.attributes["created_at"]]
      details << [I18n.t("updated_at"), @object.attributes["updated_at"]]
    end

    @details = Array.new
    details.each do |d|
      @details << [humanize(d[0]), humanize(d[1])]
    end
  end

  def initialize(_object, _options)
    @object = _object
    @options = _options
    @table_class = _options[:table_class] || "table table-striped table-bordered"

    scan_object
  end

  def to_s
    @s = render_table(@details, @table_class)
    return @s
  end
end

module ApplicationHelper
# Usage:
# use in view with bootstrap
#   = simple_show_helper(User.first)
#
# Keep in mind:
# * it uses only locales in format like this 'en.user.email'
#
# Custom attributes:
#   = simple_show_helper(User.first, attrs: ["email", "name"])
# Add created_at, updated_at:
#   = simple_show_helper(User.first, timestamps: true)
# Custom table class
#   = simple_show_helper(User.first, table_class: "table")
#
# Example:
#= raw simple_show_helper(resource, attrs: ["name"], timestamps: true, table_class: "table")

  def simple_show_helper(m, options = { })
    return SimpleShowHelper.new(m, options).to_s
  end

end
