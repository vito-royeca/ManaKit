// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RulesSearchQuery: GraphQLQuery {
  public static let operationName: String = "RulesSearch"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RulesSearch($query: String!) { rulesSearch(query: $query) { __typename count rules { __typename ...RuleInfo } } }"#,
      fragments: [RuleBasicInfo.self, RuleInfo.self]
    ))

  public var query: String

  public init(query: String) {
    self.query = query
  }

  @_spi(Unsafe) public var __variables: Variables? { ["query": query] }

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("rulesSearch", RulesSearch?.self, arguments: ["query": .variable("query")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RulesSearchQuery.Data.self
    ] }

    public var rulesSearch: RulesSearch? { __data["rulesSearch"] }

    /// RulesSearch
    ///
    /// Parent Type: `MGRules`
    nonisolated public struct RulesSearch: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRules }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("count", Int.self),
        .field("rules", [Rule].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RulesSearchQuery.Data.RulesSearch.self
      ] }

      public var count: Int { __data["count"] }
      public var rules: [Rule] { __data["rules"] }

      /// RulesSearch.Rule
      ///
      /// Parent Type: `MGRule`
      nonisolated public struct Rule: ManaKit.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(RuleInfo.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          RulesSearchQuery.Data.RulesSearch.Rule.self,
          RuleInfo.self,
          RuleBasicInfo.self
        ] }

        public var parent: Parent? { __data["parent"] }
        public var children: [Child]? { __data["children"] }
        public var id: Int { __data["id"] }
        public var term: String? { __data["term"] }
        public var termSection: String? { __data["termSection"] }
        public var definition: String? { __data["definition"] }

        public struct Fragments: FragmentContainer {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          public var ruleInfo: RuleInfo { _toFragment() }
          public var ruleBasicInfo: RuleBasicInfo { _toFragment() }
        }

        public typealias Parent = RuleInfo.Parent

        public typealias Child = RuleInfo.Child
      }
    }
  }
}
