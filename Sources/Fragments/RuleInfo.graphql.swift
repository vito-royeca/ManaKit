// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RuleInfo: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RuleInfo on MGRule { __typename ...RuleBasicInfo parent { __typename ...RuleBasicInfo } children { __typename ...RuleBasicInfo parent { __typename ...RuleBasicInfo } children { __typename ...RuleBasicInfo } } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("parent", Parent?.self),
    .field("children", [Child]?.self),
    .fragment(RuleBasicInfo.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
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

    public var ruleBasicInfo: RuleBasicInfo { _toFragment() }
  }

  /// Parent
  ///
  /// Parent Type: `MGRule`
  nonisolated public struct Parent: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(RuleBasicInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RuleInfo.Parent.self,
      RuleBasicInfo.self
    ] }

    public var id: Int { __data["id"] }
    public var term: String? { __data["term"] }
    public var termSection: String? { __data["termSection"] }
    public var definition: String? { __data["definition"] }

    public struct Fragments: FragmentContainer {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      public var ruleBasicInfo: RuleBasicInfo { _toFragment() }
    }
  }

  /// Child
  ///
  /// Parent Type: `MGRule`
  nonisolated public struct Child: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("parent", Parent?.self),
      .field("children", [Child]?.self),
      .fragment(RuleBasicInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RuleInfo.Child.self,
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

      public var ruleBasicInfo: RuleBasicInfo { _toFragment() }
    }

    /// Child.Parent
    ///
    /// Parent Type: `MGRule`
    nonisolated public struct Parent: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RuleBasicInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RuleInfo.Child.Parent.self,
        RuleBasicInfo.self
      ] }

      public var id: Int { __data["id"] }
      public var term: String? { __data["term"] }
      public var termSection: String? { __data["termSection"] }
      public var definition: String? { __data["definition"] }

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var ruleBasicInfo: RuleBasicInfo { _toFragment() }
      }
    }

    /// Child.Child
    ///
    /// Parent Type: `MGRule`
    nonisolated public struct Child: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRule }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RuleBasicInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RuleInfo.Child.Child.self,
        RuleBasicInfo.self
      ] }

      public var id: Int { __data["id"] }
      public var term: String? { __data["term"] }
      public var termSection: String? { __data["termSection"] }
      public var definition: String? { __data["definition"] }

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var ruleBasicInfo: RuleBasicInfo { _toFragment() }
      }
    }
  }
}
