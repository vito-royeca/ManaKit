// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RulesByQuery: GraphQLQuery {
  public static let operationName: String = "RulesByQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RulesByQuery($query: String!) { rulesByQuery(query: $query) { __typename count rules { __typename ...RuleInfo children { __typename ...RuleInfo } parent { __typename ...RuleInfo } } } }"#,
      fragments: [RuleInfo.self]
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
      .field("rulesByQuery", RulesByQuery?.self, arguments: ["query": .variable("query")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RulesByQuery.Data.self
    ] }

    public var rulesByQuery: RulesByQuery? { __data["rulesByQuery"] }

    /// RulesByQuery
    ///
    /// Parent Type: `MGRules`
    nonisolated public struct RulesByQuery: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRules }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("count", Int.self),
        .field("rules", [Rule].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RulesByQuery.Data.RulesByQuery.self
      ] }

      public var count: Int { __data["count"] }
      public var rules: [Rule] { __data["rules"] }

      /// RulesByQuery.Rule
      ///
      /// Parent Type: `MGRule`
      nonisolated public struct Rule: ManaKit.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("children", [Child]?.self),
          .field("parent", Parent?.self),
          .fragment(RuleInfo.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          RulesByQuery.Data.RulesByQuery.Rule.self,
          RuleInfo.self
        ] }

        public var children: [Child]? { __data["children"] }
        public var parent: Parent? { __data["parent"] }
        public var id: Int { __data["id"] }
        public var order: Double? { __data["order"] }
        public var term: String? { __data["term"] }
        public var termSection: String? { __data["termSection"] }
        public var definition: String? { __data["definition"] }

        public struct Fragments: FragmentContainer {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          public var ruleInfo: RuleInfo { _toFragment() }
        }

        /// RulesByQuery.Rule.Child
        ///
        /// Parent Type: `MGRule`
        nonisolated public struct Child: ManaKit.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(RuleInfo.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            RulesByQuery.Data.RulesByQuery.Rule.Child.self,
            RuleInfo.self
          ] }

          public var id: Int { __data["id"] }
          public var order: Double? { __data["order"] }
          public var term: String? { __data["term"] }
          public var termSection: String? { __data["termSection"] }
          public var definition: String? { __data["definition"] }

          public struct Fragments: FragmentContainer {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            public var ruleInfo: RuleInfo { _toFragment() }
          }
        }

        /// RulesByQuery.Rule.Parent
        ///
        /// Parent Type: `MGRule`
        nonisolated public struct Parent: ManaKit.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(RuleInfo.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            RulesByQuery.Data.RulesByQuery.Rule.Parent.self,
            RuleInfo.self
          ] }

          public var id: Int { __data["id"] }
          public var order: Double? { __data["order"] }
          public var term: String? { __data["term"] }
          public var termSection: String? { __data["termSection"] }
          public var definition: String? { __data["definition"] }

          public struct Fragments: FragmentContainer {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            public var ruleInfo: RuleInfo { _toFragment() }
          }
        }
      }
    }
  }
}
