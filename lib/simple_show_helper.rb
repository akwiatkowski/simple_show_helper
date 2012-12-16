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
    if options[:table_class]
      table_class = options[:table_class]
    else
      table_class = "table table-striped table-bordered"
    end

    # column used to describe association
    association_desc_keys = ["name", "email", "desc", "type", "id"]
    special_attrs = ["id", "created_at", "updated_at"]
    object_tableize = m.class.to_s.tableize.singularize

    # foreign keys, beware! magic!
    assoc_keys = m.class.reflect_on_all_associations.collect { |a| a.foreign_key }.uniq & m.attributes.keys
    # associations classes
    associations = Hash.new
    assoc_keys.each do |ak|
      associations[ak] = m.class.reflect_on_all_associations.select { |a| a.foreign_key == ak }.first.klass
    end

    if options[:attrs]
      attrs = options[:attrs].collect { |k| k.to_s }
    else
      # remove special attributes
      attrs = m.attributes.keys.sort
      special_attrs.each do |s|
        attrs.delete(s)
      end
    end

    # model's regular attributes
    details = Array.new
    attrs.each do |d|
      # key = I18n.t("#{object_tableize}.#{d}")
      key = m.class.human_attribute_name(d)
      value = m.attributes[d]

      value = case value.class.to_s
                when "Time", "ActiveSupport::TimeWithZone" then
                  l(value, format: :long)
                when "TrueClass" then
                  I18n.t(:true)
                when "FalseClass" then
                  I18n.t(:no)
                else
                  value
              end

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
    if options[:timestamps]
      #details << [m.class.human_attribute_name("created_at"), l(m.attributes["created_at"], format: :long)]
      #details << [m.class.human_attribute_name("updated_at"), l(m.attributes["updated_at"], format: :long)]
      details << [I18n.t("created_at"), l(m.attributes["created_at"], format: :long)]
      details << [I18n.t("updated_at"), l(m.attributes["updated_at"], format: :long)]
    end

    s = simple_show_helper_render_table(details, table_class)

    return s
  end

  def simple_show_helper_render_table(data, table_class)
    s = "<table class=\"#{table_class}\">"
    data.each do |dat|
      s += "<tr>\n"
      dat.each do |d|
        s += "<td>#{d}</td>\n"
      end
      s += "</tr>\n"
    end
    s += "</table>"
  end
end
