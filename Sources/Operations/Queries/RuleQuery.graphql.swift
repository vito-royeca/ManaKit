// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RuleQuery: GraphQLQuery {
  public static let operationName: String = "Rule"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Rule($id: Int!) { rule(id: $id) { __typename ...RuleInfo children { __typename ...RuleInfo } parent { __typename ...RuleInfo } } }"#,
      fragments: [RuleInfo.self]
    ))

  public var id: Int32

  public init(id: Int32) {
    self.id = id
  }

  @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("rule", Rule?.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RuleQuery.Data.self
    ] }

    public var rule: Rule? { __data["rule"] }

    /// Rule
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
        RuleQuery.Data.Rule.self,
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

      /// Rule.Child
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
          RuleQuery.Data.Rule.Child.self,
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

      /// Rule.Parent
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
          RuleQuery.Data.Rule.Parent.self,
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
