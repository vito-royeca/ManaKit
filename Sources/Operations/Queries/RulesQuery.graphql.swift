// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RulesQuery: GraphQLQuery {
  public static let operationName: String = "Rules"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Rules($id: Int) { rules(id: $id) { __typename count rules { __typename ...RuleInfo } } }"#,
      fragments: [RuleBasicInfo.self, RuleInfo.self]
    ))

  public var id: GraphQLNullable<Int32>

  public init(id: GraphQLNullable<Int32>) {
    self.id = id
  }

  @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("rules", Rules?.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RulesQuery.Data.self
    ] }

    public var rules: Rules? { __data["rules"] }

    /// Rules
    ///
    /// Parent Type: `MGRules`
    nonisolated public struct Rules: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRules }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("count", Int.self),
        .field("rules", [Rule].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RulesQuery.Data.Rules.self
      ] }

      public var count: Int { __data["count"] }
      public var rules: [Rule] { __data["rules"] }

      /// Rules.Rule
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
          RulesQuery.Data.Rules.Rule.self,
          RuleInfo.self,
          RuleBasicInfo.self
        ] }

        public var parent: Parent? { __data["parent"] }
        public var children: [Child]? { __data["children"] }
        public var id: Int { __data["id"] }
        public var order: Double? { __data["order"] }
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
