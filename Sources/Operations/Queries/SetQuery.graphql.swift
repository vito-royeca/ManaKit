// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SetQuery: GraphQLQuery {
  public static let operationName: String = "Set"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Set($input: SetByIDInput!) { set(input: $input) { __typename ...SetInfo cards { __typename ...CardBasicInfo } } }"#,
      fragments: [CardBasicInfo.self, ColorInfo.self, InnerCardInfo.self, SetBasicInfo.self, SetInfo.self]
    ))

  public var input: SetByIDInput

  public init(input: SetByIDInput) {
    self.input = input
  }

  @_spi(Unsafe) public var __variables: Variables? { ["input": input] }

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("set", Set?.self, arguments: ["input": .variable("input")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetQuery.Data.self
    ] }

    public var set: Set? { __data["set"] }

    /// Set
    ///
    /// Parent Type: `MGSet`
    nonisolated public struct Set: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("cards", [Card].self),
        .fragment(SetInfo.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SetQuery.Data.Set.self,
        SetInfo.self,
        SetBasicInfo.self
      ] }

      public var cards: [Card] { __data["cards"] }
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

      /// Set.Card
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
          SetQuery.Data.Set.Card.self,
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

      public typealias Child = SetInfo.Child

      public typealias Language = SetBasicInfo.Language

      public typealias SetBlock = SetBasicInfo.SetBlock

      public typealias SetType = SetBasicInfo.SetType
    }
  }
}
