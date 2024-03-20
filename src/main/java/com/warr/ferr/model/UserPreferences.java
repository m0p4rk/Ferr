package com.warr.ferr.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class UserPreferences {
   private int preferenceId;
   private int userId;
   private String preferredLocation;
   private AdmissionFeePreference admissionFeePreference;
   private String categoryCodeLarge;
   private String categoryCodeMedium;
   private String categoryCodeSmall;
   
   public enum AdmissionFeePreference {
      FREE,
      PAID,
      ALL
   }
}