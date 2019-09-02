AddCSLuaFile()

SWEP.PrintName          = "Become Shadow Person"
SWEP.Slot               = 6

SWEP.ViewModelFOV       = 10
SWEP.ViewModelFlip      = false
SWEP.HoldType              = "magic"
SWEP.EquipMenuData = {
type = "Shadow Person",
desc = "Use forbidden magic to become a shadow person"
};

SWEP.Icon               = "vgui/ttt/icon_shadow_person"


SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Ammo          = "none"
SWEP.Primary.Recoil        = 0
SWEP.Primary.Damage        = 0
SWEP.Primary.Delay         = 5.0
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Sound         = Sound( "Weapon_357.Single" )

SWEP.Kind                  = WEAPON_EQUIP2
SWEP.CanBuy                = { } -- only traitors can buy
SWEP.LimitedStock          = true -- only buyable once

SWEP.Tracer                = "AR2Tracer"

SWEP.UseHands              = true
SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"


function SWEP:Deploy()
  if SERVER and IsValid(self:GetOwner()) then
     self:GetOwner():DrawViewModel(false)
  end

  self:DrawShadow(false)

  return true
end

function SWEP:PrimaryAttack()
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  if not self:CanPrimaryAttack() then return end
  self:GetOwner():SetMaterial("models/invis")
  self:GetOwner():SetColor(Color(0,0,0,255))
  if SERVER then
    local magic_sound_table = {
      Sound("ambient\\atmosphere\\cave_hit1.wav"),
      Sound("ambient\\atmosphere\\cave_hit2.wav"),
      Sound("ambient\\atmosphere\\cave_hit3.wav"),
      Sound("ambient\\atmosphere\\cave_hit4.wav"),
      Sound("ambient\\atmosphere\\cave_hit5.wav"),
      Sound("ambient\\atmosphere\\cave_hit6.wav"),
      Sound("ambient\\atmosphere\\city_skybeam1.wav"),
      Sound("ambient\\atmosphere\\city_skypass1.wav")
    }
    local ply = self:GetOwner()
    sound.Play(table.Random(magic_sound_table), ply:GetPos())
    self:Remove()
  end
end

function SWEP:SecondaryAttack()
  return
end

function SWEP:CanPrimaryAttack()
  return true;
end

function SWEP:OnRemove()
  if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
     RunConsoleCommand("lastinv")
  end
  self:Holster()
end

hook.Add("PlayerSetModel", "resetPlyMaterial", function()
  for key, ply in pairs(player.GetAll() ) do
    ply:SetMaterial("")
  end
end)