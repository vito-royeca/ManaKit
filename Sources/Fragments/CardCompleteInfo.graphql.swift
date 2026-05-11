// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CardCompleteInfo: ManaKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment CardCompleteInfo on MGCard { __typename ...CardBasicInfo arenaID: arenaId cmc handModifier isBooster isDigital isFoil isFullArt isHighresImage isNonfoil isOversized isPromo isReprint isReserved isStorySpotlight isTextless lifeModifier mtgoFoilID: mtgoFoilId mtgoID: mtgoId multiverseIDs: multiverseIds releasedAt tcgplayerID: tcgplayerId toughness artists { __typename name } colorIdentities { __typename ...ColorInfo } colorIndicators { __typename ...ColorInfo } componentParts { __typename card { __typename ...CardBasicInfo } component { __typename name } } formatLegalities { __typename format { __typename name } legality { __typename name } } frame { __typename name description } frameEffects { __typename name description } rulings { __typename datePublished id text } subtypes { __typename name } watermark { __typename name } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("arenaId", alias: "arenaID", String?.self),
    .field("cmc", Int?.self),
    .field("handModifier", String?.self),
    .field("isBooster", Bool?.self),
    .field("isDigital", Bool?.self),
    .field("isFoil", Bool?.self),
    .field("isFullArt", Bool?.self),
    .field("isHighresImage", Bool?.self),
    .field("isNonfoil", Bool?.self),
    .field("isOversized", Bool?.self),
    .field("isPromo", Bool?.self),
    .field("isReprint", Bool?.self),
    .field("isReserved", Bool?.self),
    .field("isStorySpotlight", Bool?.self),
    .field("isTextless", Bool?.self),
    .field("lifeModifier", String?.self),
    .field("mtgoFoilId", alias: "mtgoFoilID", String?.self),
    .field("mtgoId", alias: "mtgoID", String?.self),
    .field("multiverseIds", alias: "multiverseIDs", [Int]?.self),
    .field("releasedAt", ManaKit.DateTime?.self),
    .field("tcgplayerId", alias: "tcgplayerID", Int?.self),
    .field("toughness", String?.self),
    .field("artists", [Artist].self),
    .field("colorIdentities", [ColorIdentity].self),
    .field("colorIndicators", [ColorIndicator].self),
    .field("componentParts", [ComponentPart].self),
    .field("formatLegalities", [FormatLegality].self),
    .field("frame", Frame?.self),
    .field("frameEffects", [FrameEffect].self),
    .field("rulings", [Ruling]?.self),
    .field("subtypes", [Subtype].self),
    .field("watermark", Watermark?.self),
    .fragment(CardBasicInfo.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
    CardCompleteInfo.self,
    CardBasicInfo.self,
    InnerCardInfo.self
  ] }

  public var arenaID: String? { __data["arenaID"] }
  public var cmc: Int? { __data["cmc"] }
  public var handModifier: String? { __data["handModifier"] }
  public var isBooster: Bool? { __data["isBooster"] }
  public var isDigital: Bool? { __data["isDigital"] }
  public var isFoil: Bool? { __data["isFoil"] }
  public var isFullArt: Bool? { __data["isFullArt"] }
  public var isHighresImage: Bool? { __data["isHighresImage"] }
  public var isNonfoil: Bool? { __data["isNonfoil"] }
  public var isOversized: Bool? { __data["isOversized"] }
  public var isPromo: Bool? { __data["isPromo"] }
  public var isReprint: Bool? { __data["isReprint"] }
  public var isReserved: Bool? { __data["isReserved"] }
  public var isStorySpotlight: Bool? { __data["isStorySpotlight"] }
  public var isTextless: Bool? { __data["isTextless"] }
  public var lifeModifier: String? { __data["lifeModifier"] }
  public var mtgoFoilID: String? { __data["mtgoFoilID"] }
  public var mtgoID: String? { __data["mtgoID"] }
  public var multiverseIDs: [Int]? { __data["multiverseIDs"] }
  public var releasedAt: ManaKit.DateTime? { __data["releasedAt"] }
  public var tcgplayerID: Int? { __data["tcgplayerID"] }
  public var toughness: String? { __data["toughness"] }
  public var artists: [Artist] { __data["artists"] }
  public var colorIdentities: [ColorIdentity] { __data["colorIdentities"] }
  public var colorIndicators: [ColorIndicator] { __data["colorIndicators"] }
  public var componentParts: [ComponentPart] { __data["componentParts"] }
  public var formatLegalities: [FormatLegality] { __data["formatLegalities"] }
  public var frame: Frame? { __data["frame"] }
  public var frameEffects: [FrameEffect] { __data["frameEffects"] }
  public var rulings: [Ruling]? { __data["rulings"] }
  public var subtypes: [Subtype] { __data["subtypes"] }
  public var watermark: Watermark? { __data["watermark"] }
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

    public var cardBasicInfo: CardBasicInfo { _toFragment() }
    public var innerCardInfo: InnerCardInfo { _toFragment() }
  }

  /// Artist
  ///
  /// Parent Type: `MGArtist`
  nonisolated public struct Artist: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGArtist }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.Artist.self
    ] }

    public var name: String { __data["name"] }
  }

  /// ColorIdentity
  ///
  /// Parent Type: `MGColor`
  nonisolated public struct ColorIdentity: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGColor }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(ColorInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.ColorIdentity.self,
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

  /// ColorIndicator
  ///
  /// Parent Type: `MGColor`
  nonisolated public struct ColorIndicator: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGColor }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(ColorInfo.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.ColorIndicator.self,
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

  /// ComponentPart
  ///
  /// Parent Type: `MGCardComponent`
  nonisolated public struct ComponentPart: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCardComponent }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("card", Card.self),
      .field("component", Component.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.ComponentPart.self
    ] }

    public var card: Card { __data["card"] }
    public var component: Component { __data["component"] }

    /// ComponentPart.Card
    ///
    /// Parent Type: `MGCard`
    nonisolated public struct Card: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(CardBasicInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CardCompleteInfo.ComponentPart.Card.self,
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

        public var cardBasicInfo: CardBasicInfo { _toFragment() }
        public var innerCardInfo: InnerCardInfo { _toFragment() }
      }

      public typealias Face = CardBasicInfo.Face

      public typealias Printing = CardBasicInfo.Printing

      public typealias OtherLanguage = CardBasicInfo.OtherLanguage

      public typealias Variation = CardBasicInfo.Variation

      public typealias Color = InnerCardInfo.Color

      public typealias Language = InnerCardInfo.Language

      public typealias Layout = InnerCardInfo.Layout

      public typealias Price = InnerCardInfo.Price

      public typealias Rarity = InnerCardInfo.Rarity

      public typealias Set = InnerCardInfo.Set

      public typealias Supertype = InnerCardInfo.Supertype
    }

    /// ComponentPart.Component
    ///
    /// Parent Type: `MGComponent`
    nonisolated public struct Component: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGComponent }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CardCompleteInfo.ComponentPart.Component.self
      ] }

      public var name: String { __data["name"] }
    }
  }

  /// FormatLegality
  ///
  /// Parent Type: `MGCardFormatLegality`
  nonisolated public struct FormatLegality: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCardFormatLegality }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("format", Format.self),
      .field("legality", Legality.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.FormatLegality.self
    ] }

    public var format: Format { __data["format"] }
    public var legality: Legality { __data["legality"] }

    /// FormatLegality.Format
    ///
    /// Parent Type: `MGFormat`
    nonisolated public struct Format: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGFormat }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CardCompleteInfo.FormatLegality.Format.self
      ] }

      public var name: String { __data["name"] }
    }

    /// FormatLegality.Legality
    ///
    /// Parent Type: `MGLegality`
    nonisolated public struct Legality: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGLegality }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CardCompleteInfo.FormatLegality.Legality.self
      ] }

      public var name: String { __data["name"] }
    }
  }

  /// Frame
  ///
  /// Parent Type: `MGFrame`
  nonisolated public struct Frame: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGFrame }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
      .field("description", String?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.Frame.self
    ] }

    public var name: String { __data["name"] }
    public var description: String? { __data["description"] }
  }

  /// FrameEffect
  ///
  /// Parent Type: `MGFrameEffect`
  nonisolated public struct FrameEffect: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGFrameEffect }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
      .field("description", String?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.FrameEffect.self
    ] }

    public var name: String { __data["name"] }
    public var description: String? { __data["description"] }
  }

  /// Ruling
  ///
  /// Parent Type: `MGRuling`
  nonisolated public struct Ruling: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGRuling }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("datePublished", ManaKit.Date.self),
      .field("id", Int.self),
      .field("text", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.Ruling.self
    ] }

    public var datePublished: ManaKit.Date { __data["datePublished"] }
    public var id: Int { __data["id"] }
    public var text: String { __data["text"] }
  }

  /// Subtype
  ///
  /// Parent Type: `MGCardType`
  nonisolated public struct Subtype: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCardType }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.Subtype.self
    ] }

    public var name: String { __data["name"] }
  }

  /// Watermark
  ///
  /// Parent Type: `MGWatermark`
  nonisolated public struct Watermark: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGWatermark }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardCompleteInfo.Watermark.self
    ] }

    public var name: String { __data["name"] }
  }

  public typealias Face = CardBasicInfo.Face

  public typealias Printing = CardBasicInfo.Printing

  public typealias OtherLanguage = CardBasicInfo.OtherLanguage

  public typealias Variation = CardBasicInfo.Variation

  public typealias Color = InnerCardInfo.Color

  public typealias Language = InnerCardInfo.Language

  public typealias Layout = InnerCardInfo.Layout

  public typealias Price = InnerCardInfo.Price

  public typealias Rarity = InnerCardInfo.Rarity

  public typealias Set = InnerCardInfo.Set

  public typealias Supertype = InnerCardInfo.Supertype
}
