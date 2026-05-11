// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SectionedSets: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment SectionedSets on MGSectionedSets { __typename count sections sectionedSets { __typename count section sets { __typename ...SetInfo } } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSectionedSets }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("count", Int.self),
    .field("sections", [String].self),
    .field("sectionedSets", [SectionedSet].self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
    SectionedSets.self
  ] }

  public var count: Int { __data["count"] }
  public var sections: [String] { __data["sections"] }
  public var sectionedSets: [SectionedSet] { __data["sectionedSets"] }

  /// SectionedSet
  ///
  /// Parent Type: `MGSectionedSet`
  nonisolated public struct SectionedSet: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSectionedSet }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("count", Int.self),
      .field("section", String.self),
      .field("sets", [Set].self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SectionedSets.SectionedSet.self
    ] }

    public var count: Int { __data["count"] }
    public var section: String { __data["section"] }
    public var sets: [Set] { __data["sets"] }

    /// SectionedSet.Set
    ///
    /// Parent Type: `MGSet`
    nonisolated public struct Set: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(SetInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SectionedSets.SectionedSet.Set.self,
        SetInfo.self,
        SetBasicInfo.self
      ] }

      public var children: [Child] { __data["children"] }
      public var id: String { __data["id"] }
      public var isOnlineOnly: Bool { __data["isOnlineOnly"] }
      public var name: String { __data["name"] }
      public var cardCount: Int? { __data["cardCount"] }
      public var keyruneUnicode: String { __data["keyruneUnicode"] }
      public var keyruneClass: String { __data["keyruneClass"] }
      public var releaseDate: String { __data["releaseDate"] }
      public var bigLogoURL: String? { __data["bigLogoURL"] }
      public var smallLogoURL: String? { __data["smallLogoURL"] }
      public var yearSection: String { __data["yearSection"] }
      public var languages: [Language] { __data["languages"] }
      public var setBlock: SetBlock? { __data["setBlock"] }
      public var setType: SetType { __data["setType"] }

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var setInfo: SetInfo { _toFragment() }
        public var setBasicInfo: SetBasicInfo { _toFragment() }
      }

      public typealias Child = SetInfo.Child

      public typealias Language = SetBasicInfo.Language

      public typealias SetBlock = SetBasicInfo.SetBlock

      public typealias SetType = SetBasicInfo.SetType
    }
  }
}
