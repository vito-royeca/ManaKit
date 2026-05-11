// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CardQuery: GraphQLQuery {
  public static let operationName: String = "Card"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Card($id: String!) { card(id: $id) { __typename ...CardCompleteInfo } }"#,
      fragments: [CardBasicInfo.self, CardCompleteInfo.self, ColorInfo.self, InnerCardInfo.self]
    ))

  public var id: String

  public init(id: String) {
    self.id = id
  }

  @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("card", Card?.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CardQuery.Data.self
    ] }

    public var card: Card? { __data["card"] }

    /// Card
    ///
    /// Parent Type: `MGCard`
    nonisolated public struct Card: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGCard }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(CardCompleteInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CardQuery.Data.Card.self,
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

        public var cardCompleteInfo: CardCompleteInfo { _toFragment() }
        public var cardBasicInfo: CardBasicInfo { _toFragment() }
        public var innerCardInfo: InnerCardInfo { _toFragment() }
      }

      public typealias Artist = CardCompleteInfo.Artist

      public typealias ColorIdentity = CardCompleteInfo.ColorIdentity

      public typealias ColorIndicator = CardCompleteInfo.ColorIndicator

      public typealias ComponentPart = CardCompleteInfo.ComponentPart

      public typealias FormatLegality = CardCompleteInfo.FormatLegality

      public typealias Frame = CardCompleteInfo.Frame

      public typealias FrameEffect = CardCompleteInfo.FrameEffect

      public typealias Ruling = CardCompleteInfo.Ruling

      public typealias Subtype = CardCompleteInfo.Subtype

      public typealias Watermark = CardCompleteInfo.Watermark

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
  }
}
