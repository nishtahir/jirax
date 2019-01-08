module JiraApi
  # Example code that deserializes and serializes the model:
  #
  # require "json"
  #
  # class Location
  #   include JSON::Serializable
  #
  #   @[JSON::Field(key: "lat")]
  #   property latitude : Float64
  #
  #   @[JSON::Field(key: "lng")]
  #   property longitude : Float64
  # end
  #
  # class House
  #   include JSON::Serializable
  #   property address : String
  #   property location : Location?
  # end
  #
  # house = House.from_json(%({"address": "Crystal Road 1234", "location": {"lat": 12.3, "lng": 34.5}}))
  # house.address  # => "Crystal Road 1234"
  # house.location # => #<Location:0x10cd93d80 @latitude=12.3, @longitude=34.5>

  class JiraPaginatedResponse
    include JSON::Serializable

    property expand : String

    @[JSON::Field(key: "startAt")]
    property start_at : Int32

    @[JSON::Field(key: "maxResults")]
    property max_results : Int32

    property total : Int32

    property issues : Array(Issue)
  end

  class Issue
    include JSON::Serializable

    property expand : String

    property id : String

    @[JSON::Field(key: "self")]
    property issue_self : String

    property key : String

    property changelog : Changelog

    property fields : Fields
  end

  class Changelog
    include JSON::Serializable

    @[JSON::Field(key: "startAt")]
    property start_at : Int32

    @[JSON::Field(key: "maxResults")]
    property max_results : Int32

    property total : Int32

    property histories : Array(History)?

    property comments : Array(JSON::Any?)?

    def getPreviousAssignees : Array(String)
      h = histories
      if (!h.nil?)
        return h.map { |item| item.getPreviousAssignees }.flatten.uniq
      end
      return [] of String
    end
  end

  class History
    include JSON::Serializable

    property id : String

    property author : Assignee?

    property created : String

    property items : Array(Item)?

    def getPreviousAssignees : Array(String)
      i = items
      if (!i.nil?)
        return i.select { |item| item.field == "assignee" }.map { |item| item.to_string }.compact
      end
      return [] of String
    end
  end

  class Assignee
    include JSON::Serializable

    @[JSON::Field(key: "self")]
    property assignee_self : String

    property name : String

    property key : String

    @[JSON::Field(key: "emailAddress")]
    property email_address : String

    @[JSON::Field(key: "displayName")]
    property display_name : String

    property active : Bool

    @[JSON::Field(key: "timeZone")]
    property time_zone : String
  end

  class Item
    include JSON::Serializable

    property field : String

    property fieldtype : String

    property from : String?

    @[JSON::Field(key: "fromString")]
    property from_string : String?

    property to : String?

    @[JSON::Field(key: "toString")]
    property to_string : String?
  end

  class Fields
    include JSON::Serializable

    property issuetype : Issuetype?

    property sprint : Sprint?

    property resolution : Prop?

    property resolutiondate : String?

    property created : String

    property epic : Epic?

    property priority : Prop?

    property labels : Array(String)

    property assignee : Assignee?

    property updated : String

    property status : Status?

    property components : Array(Prop)

    property description : String?

    property creator : Assignee?

    property reporter : Assignee?

    property duedate : Nil

    property progress : Progress?

    property summary : String
  end

  class Progress
    include JSON::Serializable

    property progress : Int32

    property total : Int32
  end

  class Prop
    include JSON::Serializable

    @[JSON::Field(key: "self")]
    property prop_self : String

    property id : String

    property name : String
  end

  class Epic
    include JSON::Serializable

    property id : Int32

    property key : String

    @[JSON::Field(key: "self")]
    property epic_self : String

    property name : String

    property summary : String

    property color : Color

    property done : Bool
  end

  class Color
    include JSON::Serializable

    property key : String
  end

  class Issuetype
    include JSON::Serializable

    @[JSON::Field(key: "self")]
    property issuetype_self : String

    property id : String

    property description : String

    @[JSON::Field(key: "iconUrl")]
    property icon_url : String

    property name : String

    property subtask : Bool

    @[JSON::Field(key: "avatarId")]
    property avatar_id : Int32
  end

  class Project
    include JSON::Serializable

    @[JSON::Field(key: "self")]
    property project_self : String

    property id : String

    property key : String

    property name : String
  end

  class Sprint
    include JSON::Serializable

    property id : Int32

    @[JSON::Field(key: "self")]
    property sprint_self : String

    property state : String

    property name : String

    @[JSON::Field(key: "startDate")]
    property start_date : String?

    @[JSON::Field(key: "endDate")]
    property end_date : String?

    @[JSON::Field(key: "originBoardId")]
    property origin_board_id : Int32

  end

  class Status
    include JSON::Serializable

    @[JSON::Field(key: "self")]
    property status_self : String

    property description : String

    @[JSON::Field(key: "iconUrl")]
    property icon_url : String

    property name : String

    property id : String

    @[JSON::Field(key: "statusCategory")]
    property status_category : StatusCategory
  end

  class StatusCategory
    include JSON::Serializable

    @[JSON::Field(key: "self")]
    property status_category_self : String

    property id : Int32

    property key : String

    @[JSON::Field(key: "colorName")]
    property color_name : String

    property name : String
  end
end
