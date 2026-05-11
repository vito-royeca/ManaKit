// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct InnerCardInfo: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment InnerCardInfo on MGCard { __typename artCropURL: artCropUrl collectorNumber displayManaCost displayName displayPowerToughness displayTypeLine id: newId faceOrder flavorText keyruneColor loyalty manaCost numberOrder name normalURL: normalUrl numberOrder oracleText pngURL: pngUrl power printedName printedText printedTypeLine toughness typeLine colors { __typename ...ColorInfo } language { __typename id: code displayID: displayCode name } layout { __typename id: code name description } prices { __typename low median high market directLow isFoil } rarity { __typename name } set { __typename name keyruneUnicode } supertypes { __typename name } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("artCropUrl", alias: "artCropURL", String?.self),
    .field("collectorNumber", String?.self),
    .field("displayManaCost", String?.self),
    .field("displayName", String?.self),
    .field("displayPowerToughness", String?.self),
    .field("displayTypeLine", String?.self),
    .field("newId", alias: "id", String.self),
    .field("faceOrder", Int?.self),
    .field("flavorText", String?.self),
    .field("keyruneColor", String?.self),
    .field("loyalty", String?.self),
    .field("manaCost", String?.self),
    .field("numberOrder", Double?.self),
    .field("name", String?.self),
    .field("normalUrl", alias: "normalURL", String?.self),
    .field("oracleText", String?.self),
    .field("pngUrl", alias: "pngURL", String?.self),
    .field("power", String?.self),
    .field("printedName", String?.self),
    .field("printedText", String?.self),
    .field("printedTypeLine", String?.self),
    .field("toughness", String?.self),
    .field("typeLine", String?.self),
    .field("colors", [Color].self),
    .field("language", Language?.self),
    .field("layout", Layout?.self),
    .field("prices", [Price]?.self),
    .field("rarity", Rarity?.self),
    .field("set", Set?.self),
    .field("supertypes", [Supertype]?.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
    InnerCardInfo.self
  ] }

  public var artCropURL: String? { __data["artCropURL"] }
  public var collectorNumber: String? { __data["collectorNumber"] }
  public var displayManaCost: String? { __data["displayManaCost"] }
  public var displayName: String? { __data["displayName"] }
  public var displayPowerToughness: String? { __data["displayPowerToughness"] }
  public var displayTypeLine: String? { __data["displayTypeLine"] }
  public var id: String { __data["id"] }
  public var faceOrder: Int? { __data["faceOrder"] }
  public var flavorText: String? { __data["flavorText"] }
  public var keyruneColor: String? { __data["keyruneColor"] }
  public var loyalty: String? { __data["loyalty"] }
  public var manaCost: String? { __data["manaCost"] }
  public var numberOrder: Double? { __data["numberOrder"] }
  public var name: String? { __data["name"] }
  public var normalURL: String? { __data["normalURL"] }
  public var oracleText: String? { __data["oracleText"] }
  public var pngURL: String? { __data["pngURL"] }
  public var power: String? { __data["power"] }
  public var printedName: String? { __data["printedName"] }
  public var printedText: String? { __data["printedText"] }
  public var printedTypeLine: String? { __data["printedTypeLine"] }
  public var toughness: String? { __data["toughness"] }
  public var typeLine: String? { __data["typeLine"] }
  public var colors: [Color] { __data["colors"] }
  public var language: Language? { __data["language"] }
  public var layout: Layout? { __data["layout"] }
  public var prices: [Price]? { __data["prices"] }
  public var rarity: Rarity? { __data["rarity"] }
  public var set: Set? { __data["set"] }
  public var supertypes: [Supertype]? { __data["supertypes"] }

  /// Color
  ///
  /// Parent Type: `MGColor`
  nonisolated public struct Color: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGColor }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(ColorInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      InnerCardInfo.Color.self,
      ColorInfo.self
    ] }

    public var name: String { __data["name"] }
    public var symbol: String { __data["symbol"] }

    public struct Fragments: FragmentContainer {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      public var colorInfo: ColorInfo { _toFragment() }
    }
  }

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
      InnerCardInfo.Language.self
    ] }

    public var id: String { __data["id"] }
    public var displayID: String? { __data["displayID"] }
    public var name: String { __data["name"] }
  }

  /// Layout
  ///
  /// Parent Type: `MGLayout`
  nonisolated public struct Layout: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGLayout }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("code", alias: "id", String.self),
      .field("name", String.self),
      .field("description", String?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      InnerCardInfo.Layout.self
    ] }

    public var id: String { __data["id"] }
    public var name: String { __data["name"] }
    public var description: String? { __data["description"] }
  }

  /// Price
  ///
  /// Parent Type: `MGCardPrice`
  nonisolated public struct Price: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCardPrice }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("low", Double?.self),
      .field("median", Double?.self),
      .field("high", Double?.self),
      .field("market", Double?.self),
      .field("directLow", Double?.self),
      .field("isFoil", Bool?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      InnerCardInfo.Price.self
    ] }

    public var low: Double? { __data["low"] }
    public var median: Double? { __data["median"] }
    public var high: Double? { __data["high"] }
    public var market: Double? { __data["market"] }
    public var directLow: Double? { __data["directLow"] }
    public var isFoil: Bool? { __data["isFoil"] }
  }

  /// Rarity
  ///
  /// Parent Type: `MGRarity`
  nonisolated public struct Rarity: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRarity }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      InnerCardInfo.Rarity.self
    ] }

    public var name: String { __data["name"] }
  }

  /// Set
  ///
  /// Parent Type: `MGSet`
  nonisolated public struct Set: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
      .field("keyruneUnicode", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      InnerCardInfo.Set.self
    ] }

    public var name: String { __data["name"] }
    public var keyruneUnicode: String { __data["keyruneUnicode"] }
  }

  /// Supertype
  ///
  /// Parent Type: `MGCardType`
  nonisolated public struct Supertype: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCardType }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      InnerCardInfo.Supertype.self
    ] }

    public var name: String { __data["name"] }
  }
}
