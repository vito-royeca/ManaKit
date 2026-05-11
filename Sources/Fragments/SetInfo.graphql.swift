// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SetInfo: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment SetInfo on MGSet { __typename ...SetBasicInfo children { __typename ...SetBasicInfo children { __typename ...SetBasicInfo children { __typename ...SetBasicInfo } } } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("children", [Child].self),
    .fragment(SetBasicInfo.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
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

    public var setBasicInfo: SetBasicInfo { _toFragment() }
  }

  /// Child
  ///
  /// Parent Type: `MGSet`
  nonisolated public struct Child: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("children", [Child].self),
      .fragment(SetBasicInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetInfo.Child.self,
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

      public var setBasicInfo: SetBasicInfo { _toFragment() }
    }

    /// Child.Child
    ///
    /// Parent Type: `MGSet`
    nonisolated public struct Child: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("children", [Child].self),
        .fragment(SetBasicInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SetInfo.Child.Child.self,
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

        public var setBasicInfo: SetBasicInfo { _toFragment() }
      }

      /// Child.Child.Child
      ///
      /// Parent Type: `MGSet`
      nonisolated public struct Child: ManaKit.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(SetBasicInfo.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          SetInfo.Child.Child.Child.self,
          SetBasicInfo.self
        ] }

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

          public var setBasicInfo: SetBasicInfo { _toFragment() }
        }

        public typealias Language = SetBasicInfo.Language

        public typealias SetBlock = SetBasicInfo.SetBlock

        public typealias SetType = SetBasicInfo.SetType
      }

      public typealias Language = SetBasicInfo.Language

      public typealias SetBlock = SetBasicInfo.SetBlock

      public typealias SetType = SetBasicInfo.SetType
    }

    public typealias Language = SetBasicInfo.Language

    public typealias SetBlock = SetBasicInfo.SetBlock

    public typealias SetType = SetBasicInfo.SetType
  }

  public typealias Language = SetBasicInfo.Language

  public typealias SetBlock = SetBasicInfo.SetBlock

  public typealias SetType = SetBasicInfo.SetType
}
