require "http/client"
require "json"
require "csv"
require "poncho"

require "./jira_api"
require "./model"

module Jirax
  poncho = Poncho.from_file ".env"
  host = poncho["JIRA_URL"]
  username = poncho["USERNAME"]
  password = poncho["PASSWORD"]
  api = JiraApi::Client.new(username, password, host)
  issues = api.getIssuesForSprint(622, 1172, expand: ["changelog"])

  result = CSV.build do |csv|
    issues.each { |issue|
      fields = issue.fields
      changelog = issue.changelog

      id = issue.key

      epic = fields.epic
      summary = fields.summary
      issue_type = fields.issuetype
      status = fields.status

      epic_name = epic.nil? ? "" : epic.name
      issue_type_name = issue_type.nil? ? "" : issue_type.name
      status_name = status.nil? ? "" : status.name
      resolutiondate = if (date = fields.resolutiondate)
                         time = Time.parse_local(date, "%F")
                         time.to_s("%D")
                       else
                         ""
                       end
      labels = fields.labels.join(", ")
      assginees = changelog.getPreviousAssignees
      csv.row([id, epic_name, summary, issue_type_name, status_name, labels, resolutiondate] + assginees)
    }
  end

  # puts result
end
