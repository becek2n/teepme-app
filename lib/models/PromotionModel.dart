class PromotionModel
{
    final int id;
    final String title;
    final String desc;
    final String images;

    PromotionModel({
      this.id,
      this.title,
      this.desc,
      this.images,
    });

    factory PromotionModel.fromJSON(Map<String, dynamic> jsonMap) 
    {
      final data = PromotionModel( 
        id: jsonMap["ID"],
        title: jsonMap["Title"],
        desc: jsonMap["Desc"],
        images: jsonMap["Images"]);
      return data;
    }

}
