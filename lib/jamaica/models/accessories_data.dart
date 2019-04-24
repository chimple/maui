class AccessoryData {
  final String imagePath;
  final String accessoryName;
  final int coin;

  AccessoryData(this.imagePath, this.accessoryName, this.coin);
}

class AccessoryCategory {
  final String accessoryCategoryImagePath;
  final String accessoryCategoryName;

  AccessoryCategory(
      this.accessoryCategoryImagePath, this.accessoryCategoryName);
}

Map<AccessoryCategory, List<AccessoryData>> list = {
  AccessoryCategory('assets/accessories/alphabet.png', 'Hat'): [
    AccessoryData('assets/accessories/hat_acc/hat1', 'hat1', 100),
    AccessoryData('assets/accessories/hat_acc/hat2', 'hat2', 100),
    AccessoryData('assets/accessories/hat_acc/hat3', 'hat3', 100),
    AccessoryData('assets/accessories/hat_acc/hat4', 'hat4', 100),
    AccessoryData('assets/accessories/hat_acc/hat5', 'hat5', 100),
    AccessoryData('assets/accessories/hat_acc/hat6', 'hat6', 100),
    AccessoryData('assets/accessories/hat_acc/hat7', 'hat7', 100),
    AccessoryData('assets/accessories/hat_acc/hat8', 'hat8', 100),
    AccessoryData('assets/accessories/hat_acc/hat9', 'hat9', 100),
    AccessoryData('assets/accessories/hat_acc/hat10', 'hat10', 100),
    AccessoryData('assets/accessories/hat_acc/hat11', 'hat11', 100),
  ],
  AccessoryCategory('assets/accessories/animal.png', 'Head'): [
    AccessoryData('assets/accessories/head_acc/head1', 'head1', 100),
    AccessoryData('assets/accessories/head_acc/head2', 'head2', 100),
    AccessoryData('assets/accessories/head_acc/head3', 'head3', 100),
    AccessoryData('assets/accessories/head_acc/head4', 'head4', 100),
    AccessoryData('assets/accessories/head_acc/head5', 'head5', 100),
    AccessoryData('assets/accessories/head_acc/head6', 'head6', 100),
    AccessoryData('assets/accessories/head_acc/head7', 'head7', 100),
    AccessoryData('assets/accessories/head_acc/head8', 'head8', 100),
    AccessoryData('assets/accessories/head_acc/head9', 'head9', 100),
    AccessoryData('assets/accessories/head_acc/head10', 'head10', 100),
  ],
  AccessoryCategory('assets/accessories/camera.png', 'Neck'): [
    AccessoryData('assets/accessories/neck_acc/neck1', 'neck1', 100),
    AccessoryData('assets/accessories/neck_acc/neck2', 'neck2', 100),
    AccessoryData('assets/accessories/neck_acc/neck3', 'neck3', 100),
    AccessoryData('assets/accessories/neck_acc/neck4', 'neck4', 100),
    AccessoryData('assets/accessories/neck_acc/neck5', 'neck5', 100),
    AccessoryData('assets/accessories/neck_acc/neck6', 'neck6', 100),
    AccessoryData('assets/accessories/neck_acc/neck7', 'neck7', 100),
    AccessoryData('assets/accessories/neck_acc/neck8', 'neck8', 100),
    AccessoryData('assets/accessories/neck_acc/neck9', 'neck9', 100),
    AccessoryData('assets/accessories/neck_acc/neck10', 'neck10', 100),
  ],
  AccessoryCategory('assets/accessories/clothes.png', 'Glasses'): [
    AccessoryData('assets/accessories/glasses_acc/glasses1', 'glasses1', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses2', 'glasses2', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses3', 'glasses3', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses4', 'glasses4', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses5', 'glasses5', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses6', 'glasses6', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses7', 'glasses7', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses8', 'glasses8', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses9', 'glasses9', 100),
    AccessoryData('assets/accessories/glasses_acc/glasses10', 'glasses10', 100),
  ],
  AccessoryCategory('assets/accessories/electronic.png', 'Flag'): [
    AccessoryData('assets/accessories/flag_acc/flag1', 'flag1', 100),
    AccessoryData('assets/accessories/flag_acc/flag2', 'flag2', 100),
    AccessoryData('assets/accessories/flag_acc/flag3', 'flag3', 100),
    AccessoryData('assets/accessories/flag_acc/flag4', 'flag4', 100),
    AccessoryData('assets/accessories/flag_acc/flag5', 'flag5', 100),
    AccessoryData('assets/accessories/flag_acc/flag6', 'flag6', 100),
    AccessoryData('assets/accessories/flag_acc/flag7', 'flag7', 100),
    AccessoryData('assets/accessories/flag_acc/flag8', 'flag8', 100),
    AccessoryData('assets/accessories/flag_acc/flag9', 'flag9', 100),
    AccessoryData('assets/accessories/flag_acc/flag10', 'flag10', 100),
  ],
  AccessoryCategory('assets/accessories/emotion.png', 'Braclet'): [
    AccessoryData('assets/accessories/brac_acc/brac1', 'brac1', 100),
    AccessoryData('assets/accessories/brac_acc/brac2', 'brac2', 100),
    AccessoryData('assets/accessories/brac_acc/brac3', 'brac3', 100),
    AccessoryData('assets/accessories/brac_acc/brac4', 'brac4', 100),
    AccessoryData('assets/accessories/brac_acc/brac5', 'brac5', 100),
    AccessoryData('assets/accessories/brac_acc/brac6', 'brac6', 100),
    AccessoryData('assets/accessories/brac_acc/brac7', 'brac7', 100),
    AccessoryData('assets/accessories/brac_acc/brac8', 'brac8', 100),
    AccessoryData('assets/accessories/brac_acc/brac9', 'brac9', 100),
    AccessoryData('assets/accessories/brac_acc/brac10', 'brac10', 100),
  ],
  AccessoryCategory('assets/accessories/fruit.png', 'Antenna'): [
    AccessoryData('assets/accessories/antenna_acc/antenna1', 'antenna1', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna2', 'antenna2', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna3', 'antenna3', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna4', 'antenna4', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna5', 'antenna5', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna6', 'antenna6', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna7', 'antenna7', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna8', 'antenna8', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna9', 'antenna9', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna10', 'antenna10', 100),
  ],
  AccessoryCategory('assets/accessories/fruit.png', 'Antenna'): [
    AccessoryData('assets/accessories/antenna_acc/antenna1', 'antenna1', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna2', 'antenna2', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna3', 'antenna3', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna4', 'antenna4', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna5', 'antenna5', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna6', 'antenna6', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna7', 'antenna7', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna8', 'antenna8', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna9', 'antenna9', 100),
    AccessoryData('assets/accessories/antenna_acc/antenna10', 'antenna10', 100),
  ],
};
