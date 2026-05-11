// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SetBasicInfo: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment SetBasicInfo on MGSet { __typename id: code isOnlineOnly name cardCount keyruneUnicode keyruneClass releaseDate bigLogoURL smallLogoURL yearSection languages { __typename id: code displayID: displayCode name } setBlock { __typename name } setType { __typename name } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("code", alias: "id", String.self),
    .field("isOnlineOnly", Bool.self),
    .field("name", String.self),
    .field("cardCount", Int?.self),
    .field("keyruneUnicode", String.self),
    .field("keyruneClass", String.self),
    .field("releaseDate", String.self),
    .field("bigLogoURL", String?.self),
    .field("smallLogoURL", String?.self),
    .field("yearSection", String.self),
    .field("languages", [Language].self),
    .field("setBlock", SetBlock?.self),
    .field("setType", SetType.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
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

  /// Language
  ///
  /// Parent Type: `MGLanguage`
  nonisolated public struct Language: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGLanguage }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("code", alias: "id", String.self),
      .field("displayCode", alias: "displayID", String?.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetBasicInfo.Language.self
    ] }

    public var id: String { __data["id"] }
    public var displayID: String? { __data["displayID"] }
    public var name: String { __data["name"] }
  }

  /// SetBlock
  ///
  /// Parent Type: `MGSetBlock`
  nonisolated public struct SetBlock: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSetBlock }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetBasicInfo.SetBlock.self
    ] }

    public var name: String { __data["name"] }
  }

  /// SetType
  ///
  /// Parent Type: `MGSetType`
  nonisolated public struct SetType: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSetType }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetBasicInfo.SetType.self
    ] }

    public var name: String { __data["name"] }
  }
}
