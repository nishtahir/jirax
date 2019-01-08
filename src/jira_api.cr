module JiraApi
  class Client
    def initialize(username : String, password : String, http_client : HTTP::Client)
      http_client.basic_auth(username, password)
      http_client.before_request do |request|
        request.headers["Accept"] = "*/*"
      end
      @http_client = http_client
    end

    def initialize(username : String, password : String, host : String)
      initialize(username, password, HTTP::Client.new(host, tls: true))
    end

    def getAllBoards
      response = @http_client.get("/rest/agile/1.0/board")
      puts response.body.to_s
    end

    def getBoard(board_id : Int32)
      response = @http_client.get("/rest/agile/1.0/board/#{id}")
      puts response.body.to_s
    end

    def getAllSprints(board_id : Int32)
      response = @http_client.get("/rest/agile/1.0/board/#{board_id}/sprint")
      puts response.body.to_s
    end

    def getIssuesForSprint(board_id : Int32, sprint_id : Int32, expand : Array(String)? = nil, maxResults : Int32? = nil) : Array(Issue)
      url = "/rest/agile/1.0/board/#{board_id}/sprint/#{sprint_id}/issue/"

      params = HTTP::Params::Builder.new
      params.add("expand", expand.join(",")) unless expand.nil?
      params.add("maxResults", maxResults) unless maxResults.nil?
      url += "?" + params.to_s

      response = @http_client.get(url)

      case response.status_code
      when 200
        JiraPaginatedResponse.from_json(response.body).issues
      else
        raise Exception.new(response.body.to_s)
      end
    end
  end
end
