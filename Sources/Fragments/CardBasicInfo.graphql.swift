// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CardBasicInfo: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment CardBasicInfo on MGCard { __typename ...InnerCardInfo faces { __typename ...InnerCardInfo } printings: otherPrintings { __typename ...InnerCardInfo } otherLanguages { __typename ...InnerCardInfo } variations { __typename ...InnerCardInfo } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("faces", [Face].self),
    .field("otherPrintings", alias: "printings", [Printing].self),
    .field("otherLanguages", [OtherLanguage].self),
    .field("variations", [Variation].self),
    .fragment(InnerCardInfo.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
    CardBasicInfo.self,
    InnerCardInfo.self
  ] }

  public var faces: [Face] { __data["faces"] }
  public var printings: [Printing] { __data["printings"] }
  public var otherLanguages: [OtherLanguage] { __data["otherLanguages"] }
  public var variations: [Variation] { __data["variations"] }
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

  public struct Fragments: FragmentContainer {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    public var innerCardInfo: InnerCardInfo { _toFragment() }
  }

  /// Face
  ///
  /// Parent Type: `MGCard`
  nonisolated public struct Face: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(InnerCardInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardBasicInfo.Face.self,
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

    public struct Fragments: FragmentContainer {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      public var innerCardInfo: InnerCardInfo { _toFragment() }
    }

    public typealias Color = InnerCardInfo.Color

    public typealias Language = InnerCardInfo.Language

    public typealias Layout = InnerCardInfo.Layout

    public typealias Price = InnerCardInfo.Price

    public typealias Rarity = InnerCardInfo.Rarity

    public typealias Set = InnerCardInfo.Set

    public typealias Supertype = InnerCardInfo.Supertype
  }

  /// Printing
  ///
  /// Parent Type: `MGCard`
  nonisolated public struct Printing: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(InnerCardInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardBasicInfo.Printing.self,
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

    public struct Fragments: FragmentContainer {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      public var innerCardInfo: InnerCardInfo { _toFragment() }
    }

    public typealias Color = InnerCardInfo.Color

    public typealias Language = InnerCardInfo.Language

    public typealias Layout = InnerCardInfo.Layout

    public typealias Price = InnerCardInfo.Price

    public typealias Rarity = InnerCardInfo.Rarity

    public typealias Set = InnerCardInfo.Set

    public typealias Supertype = InnerCardInfo.Supertype
  }

  /// OtherLanguage
  ///
  /// Parent Type: `MGCard`
  nonisolated public struct OtherLanguage: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(InnerCardInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardBasicInfo.OtherLanguage.self,
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

    public struct Fragments: FragmentContainer {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      public var innerCardInfo: InnerCardInfo { _toFragment() }
    }

    public typealias Color = InnerCardInfo.Color

    public typealias Language = InnerCardInfo.Language

    public typealias Layout = InnerCardInfo.Layout

    public typealias Price = InnerCardInfo.Price

    public typealias Rarity = InnerCardInfo.Rarity

    public typealias Set = InnerCardInfo.Set

    public typealias Supertype = InnerCardInfo.Supertype
  }

  /// Variation
  ///
  /// Parent Type: `MGCard`
  nonisolated public struct Variation: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(InnerCardInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardBasicInfo.Variation.self,
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

    public struct Fragments: FragmentContainer {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      public var innerCardInfo: InnerCardInfo { _toFragment() }
    }

    public typealias Color = InnerCardInfo.Color

    public typealias Language = InnerCardInfo.Language

    public typealias Layout = InnerCardInfo.Layout

    public typealias Price = InnerCardInfo.Price

    public typealias Rarity = InnerCardInfo.Rarity

    public typealias Set = InnerCardInfo.Set

    public typealias Supertype = InnerCardInfo.Supertype
  }

  public typealias Color = InnerCardInfo.Color

  public typealias Language = InnerCardInfo.Language

  public typealias Layout = InnerCardInfo.Layout

  public typealias Price = InnerCardInfo.Price

  public typealias Rarity = InnerCardInfo.Rarity

  public typealias Set = InnerCardInfo.Set

  public typealias Supertype = InnerCardInfo.Supertype
}
